-- 17. Assess revenue volatility for each product. 
-- CV = (Standard Deviation / Average) × 100
create or replace view vw_product_volatility as
with monthly_revenue as (
    select f.product_key, d.year, d.month, sum(f.net_amount) as monthly_revenue
    from fact_order_line f
    join dim_date d on f.date_key = d.date_key
    group by f.product_key, d.year, d.month
),
stats as (
    select product_key,
           round(avg(monthly_revenue) over (partition by product_key), 2) as avg_monthly_revenue,
           round(stddev(monthly_revenue) over (partition by product_key), 2) as revenue_stddev,
           count(*) over (partition by product_key) as months_active
    from monthly_revenue
)
select distinct product_key, months_active, avg_monthly_revenue, revenue_stddev,
       round(revenue_stddev / nullif(avg_monthly_revenue, 0) * 100, 2) as volatility_pct,
       case
           when revenue_stddev / nullif(avg_monthly_revenue, 0) * 100 < 30 then 'stable'
           when revenue_stddev / nullif(avg_monthly_revenue, 0) * 100 < 60 then 'moderate'
           else 'highly volatile'
       end as volatility_label,
       rank() over (order by revenue_stddev / nullif(avg_monthly_revenue, 0) desc) as volatility_rank
from stats;

select dp.product_name, v.months_active, v.avg_monthly_revenue,
       v.revenue_stddev, v.volatility_pct, v.volatility_label, v.volatility_rank
from vw_product_volatility v
join dim_product dp on v.product_key = dp.product_key
order by v.volatility_pct desc;
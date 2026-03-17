-- 17. Assess revenue volatility for each product. 
-- CV = (Standard Deviation / Average) × 100
with monthly_revenue as (
    select p.product_name, d.year, d.month, sum(f.net_amount) as monthly_revenue
    from fact_order_line f
    join dim_product p on f.product_key = p.product_key
    join dim_date d on f.date_key = d.date_key
    group by p.product_name, d.year, d.month
),
volatility as (
    select product_name,
           round(avg(monthly_revenue) over (partition by product_name), 2) as avg_monthly_revenue,
           round(stddev(monthly_revenue) over (partition by product_name), 2) as revenue_stddev,
           count(*) over (partition by product_name) as months_active
    from monthly_revenue
)
select distinct product_name, months_active, avg_monthly_revenue, revenue_stddev,
       round(revenue_stddev / nullif(avg_monthly_revenue, 0) * 100, 2) as volatility_pct,
       case
           when revenue_stddev / nullif(avg_monthly_revenue, 0) * 100 < 30 then 'stable'
           when revenue_stddev / nullif(avg_monthly_revenue, 0) * 100 < 60 then 'moderate'
           else 'highly volatile'
       end as volatility_label,
       rank() over (order by revenue_stddev / nullif(avg_monthly_revenue, 0) desc) as volatility_rank
from volatility
order by volatility_pct desc;


-- 18. Detect trending categories based on recent performance compared to historical behavior. 
-- Recent avg > Historical avg = Trending Up
-- Recent avg < Historical avg = Trending Down
with monthly_cat as (
    select c.category_name, d.year, d.month, sum(f.net_amount) as monthly_revenue
    from fact_order_line f
    join dim_category c on f.category_key = c.category_key
    join dim_date d on f.date_key = d.date_key
    group by c.category_name, d.year, d.month
),
trend as (
    select category_name, year, month,
           round(avg(monthly_revenue) over (partition by category_name order by year, month rows between 2 preceding and current row), 2) as recent_3m_avg,
           round(avg(monthly_revenue) over (partition by category_name), 2) as historical_avg,
           row_number() over (partition by category_name order by year desc, month desc) as rn
    from monthly_cat
)
select category_name, historical_avg, recent_3m_avg,
       round((recent_3m_avg - historical_avg) / nullif(historical_avg, 0) * 100, 2) as trend_pct,
       case
           when recent_3m_avg > historical_avg then 'trending up'
           else 'trending down'
       end as trend_status
from trend
where rn = 1
order by trend_pct desc;



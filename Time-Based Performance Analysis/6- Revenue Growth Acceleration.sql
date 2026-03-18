-- 6. Identify acceleration or deceleration in revenue dynamics. 
-- Compares current month's growth rate vs previous month's growth rate.
-- If growth rate is increasing -> Accelerating, if decreasing -> Decelerating.
-- growth_rate_pct = (curr − prev) / prev x 100
with monthly_rev as (
    select d.year, d.month, sum(f.net_amount) as current_revenue
    from fact_order_line f
    join dim_date d on f.date_key = d.date_key
    group by d.year, d.month
),
growth as (
    select year, month,
           round((current_revenue - lag(current_revenue) over (order by year, month)) 
           / nullif(lag(current_revenue) over (order by year, month), 0) * 100, 2) as growth_rate_pct
    from monthly_rev
),
acceleration as (
    select year, month, growth_rate_pct,
           lag(growth_rate_pct) over (order by year, month) as prev_growth_rate_pct
    from growth
)
select year, month, growth_rate_pct, prev_growth_rate_pct,
       round(growth_rate_pct - prev_growth_rate_pct, 2) as acceleration_pct,
       case
           when prev_growth_rate_pct is null then 'n/a'
           when growth_rate_pct - prev_growth_rate_pct > 0 then 'accelerating'
           when growth_rate_pct - prev_growth_rate_pct = 0 then 'stable'
           else 'decelerating'
       end as dynamics_label
from acceleration
order by year, month;
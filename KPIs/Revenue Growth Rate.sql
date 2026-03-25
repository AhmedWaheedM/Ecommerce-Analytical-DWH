-- kpi 7: revenue growth rate (month over month)
with monthly_revenue as (
    select d.year, d.month, d.month_name, sum(f.net_amount) as current_revenue
    from fact_order_line f
    join dim_date d on f.date_key = d.date_key
    group by d.year, d.month, d.month_name
)
select year, month, month_name,
       round(current_revenue, 2) as current_revenue,
       round(lag(current_revenue) over (order by year, month), 2) as previous_revenue,
       round(current_revenue - lag(current_revenue) over (order by year, month), 2) as revenue_change,
       case
           when lag(current_revenue) over (order by year, month) is null then null
           else round((current_revenue - lag(current_revenue) over (order by year, month)) / 
           nullif(lag(current_revenue) over (order by year, month), 0) * 100, 2)
       end as revenue_growth_rate_pct
from monthly_revenue
order by year, month;

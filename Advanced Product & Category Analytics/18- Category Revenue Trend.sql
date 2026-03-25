-- 18. Detect trending categories based on recent performance compared to historical behavior. 
-- Recent avg > Historical avg = Trending Up
-- Recent avg < Historical avg = Trending Down
create or replace view vw_category_trend as
with monthly_cat as (
    select c.category_name, f.category_key, d.year, d.month, sum(f.net_amount) as monthly_revenue
    from fact_order_line f
    join dim_category c on f.category_key = c.category_key
    join dim_date d on f.date_key = d.date_key
    group by c.category_name, f.category_key, d.year, d.month
),
trend as (
    select category_name, category_key, year, month,
           round(avg(monthly_revenue) over (partition by category_name order by year, month rows between 2 preceding and current row), 2) as recent_3m_avg,
           round(avg(monthly_revenue) over (partition by category_name), 2) as historical_avg,
           row_number() over (partition by category_name order by year desc, month desc) as rn
    from monthly_cat
)
select category_name, category_key, historical_avg, recent_3m_avg,
       round((recent_3m_avg - historical_avg) / nullif(historical_avg, 0) * 100, 2) as trend_pct,
       case when recent_3m_avg > historical_avg then 'trending up' else 'trending down' end as trend_status
from trend
where rn = 1;

select category_name, historical_avg, recent_3m_avg, trend_pct, trend_status
from vw_category_trend
order by trend_pct desc;
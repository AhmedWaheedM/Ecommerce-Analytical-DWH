-- kpi 3: average order value (aov)
select count(distinct order_id) as total_orders,
       round(sum(net_amount) / count(distinct order_id), 2) as avg_order_value
from fact_order_line;

-- aov per month
select d.year, d.month, d.month_name,
       count(distinct f.order_id) as total_orders,
       round(sum(f.net_amount) / count(distinct f.order_id), 2) as avg_order_value
from fact_order_line f
join dim_date d on f.date_key = d.date_key
group by d.year, d.month, d.month_name
order by d.year, d.month;
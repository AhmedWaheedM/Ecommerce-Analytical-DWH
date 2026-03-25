-- kpi 5: repeat purchase rate
with customer_order_count as (
    select customer_key, count(distinct order_id) as total_orders
    from fact_order_line
    group by customer_key
)
select count(*) as total_customers,
       sum(case when total_orders > 1 then 1 else 0 end) as repeat_customers,
       round(sum(case when total_orders > 1 then 1 else 0 end) / count(*) * 100, 2) as repeat_purchase_rate_pct
from customer_order_count;
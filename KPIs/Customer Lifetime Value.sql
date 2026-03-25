-- kpi 4: customer lifetime value (clv)
select c.customer_id, c.gender, c.age_group, c.customer_segment,
       count(distinct f.order_id) as total_orders,
       round(sum(f.net_amount), 2) as lifetime_value
from fact_order_line f
join dim_customer c on f.customer_key = c.customer_key
group by c.customer_id, c.gender, c.age_group, c.customer_segment
order by lifetime_value desc;

-- average clv across all customers
select round(avg(lifetime_value), 2) as avg_customer_lifetime_value
from (
    select f.customer_key, sum(f.net_amount) as lifetime_value
    from fact_order_line f
    group by f.customer_key
) clv_base;
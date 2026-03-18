-- 9. Identify high-impact products contributing to the majority of revenue (Pareto analysis).
-- Cumulative revenue % per product, products within first 80% are high impact (80/20 rule)
-- cumulative_pct = running total / grand total x 100
with product_revenue as (
    select p.product_name, sum(f.net_amount) as total_revenue
    from fact_order_line f
    join dim_product p on f.product_key = p.product_key
    group by p.product_name
),
ranked as (
    select product_name, total_revenue,
           round(sum(total_revenue) over (order by total_revenue desc) 
           / sum(total_revenue) over () * 100, 2) as cumulative_pct
    from product_revenue
)
select product_name, total_revenue, cumulative_pct,
       case
           when cumulative_pct <= 80 then 'high impact'
           else 'low impact'
       end as pareto_label
from ranked
order by total_revenue desc;
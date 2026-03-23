-- 9. Identify high-impact products contributing to the majority of revenue (Pareto analysis).
-- Cumulative revenue % per product, products within first 80% are high impact (80/20 rule)
-- cumulative_pct = running total / grand total x 100
create or replace view vw_pareto as
with product_revenue as (
    select product_key, sum(net_amount) as total_revenue
    from fact_order_line
    group by product_key
)
select product_key, total_revenue,
       round(sum(total_revenue) over (order by total_revenue desc) / sum(total_revenue) over () * 100, 2) as cumulative_pct,
       case
           when round(sum(total_revenue) over (order by total_revenue desc) / sum(total_revenue) over () * 100, 2) <= 80 then 1
           else 0
       end as is_high_impact
from product_revenue;

select dp.product_name, p.total_revenue, p.cumulative_pct,
       case when p.is_high_impact = 1 then 'high impact' else 'low impact' end as pareto_label
from vw_pareto p
join dim_product dp on p.product_key = dp.product_key
order by p.total_revenue desc;
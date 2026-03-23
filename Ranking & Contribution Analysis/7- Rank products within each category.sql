-- 7. Rank products within each category based on revenue performance.

create or replace view vw_product_revenue_rank as
with revenue as (
    select f.category_key, d.product_key, d.product_name,
           sum(f.net_amount) as total_revenue,
           rank() over (partition by f.category_key order by sum(f.net_amount) desc) as rank_in_category
    from fact_order_line f
    join dim_product d on f.product_key = d.product_key
    group by f.category_key, d.product_key, d.product_name
)
select * from revenue;

select r.rank_in_category, c.category_name, r.product_name, r.total_revenue
from vw_product_revenue_rank r
join dim_category c on r.category_key = c.category_key
order by c.category_name, r.rank_in_category;
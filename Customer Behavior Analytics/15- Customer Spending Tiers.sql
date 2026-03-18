-- 15. Segment customers into spending tiers (e.g., quartiles). 
with customer_spending as (
    select c.customer_id, sum(f.net_amount) as total_spending
    from fact_order_line f
    join dim_customer c on f.customer_key = c.customer_key
    group by c.customer_id
)
select customer_id, total_spending,
       ntile(4) over (order by total_spending) as quartile,
       case ntile(4) over (order by total_spending)
           when 1 then 'low spender'
           when 2 then 'mid spender'
           when 3 then 'high spender'
           when 4 then 'top spender'
       end as spending_tier
from customer_spending
order by total_spending desc;
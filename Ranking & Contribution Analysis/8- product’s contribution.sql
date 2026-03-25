-- 8. Determine each product’s contribution to its category’s total revenue. 

CREATE OR REPLACE VIEW product_contribution AS
with product_revenue as (
   select category_key,
          product_key,
          sum(net_amount) as product_revenue
     from fact_order_line
    group by category_key,
             product_key
),category_revenue as (
   select category_key,
          sum(net_amount) as category_revenue
     from fact_order_line
    group by category_key
)
SELECT category_key, category_revenue
FROM category_revenue;


select * from product_contribution;
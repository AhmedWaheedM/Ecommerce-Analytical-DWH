-- Use ecommerce_Dw;

-- check all products in our business
select f.order_id,
       f.product_key,
       dp.product_name,
       f.category_key,
       dc.category_name,
       f.net_amount,
       dd.full_date
  from fact_order_line f
  join dim_product dp
on f.product_key = dp.product_key
  join dim_category dc
on f.category_key = dc.category_key
  join dim_date dd
on f.date_key = dd.date_key;


-- check products bought together in the same order
with product_pairs as (
   select -- a.product_key as first_product,
          dp.product_name as first_product_name,
          dc.category_name as fisrt_category_name,
          -- b.product_key as second_product,
          dp2.product_name as second_product_name,
          dc2.category_name as second_category_name,

          CASE 
            WHEN a.category_key = b.category_key THEN 'Same Category'
            ELSE 'Different Category'
        END AS Relation_Type

     from fact_order_line a
     join fact_order_line b
   on a.order_id = b.order_id
      and a.product_key < b.product_key
     join dim_product dp
   on a.product_key = dp.product_key
     join dim_product dp2
   on b.product_key = dp2.product_key
     join dim_category dc
   on a.category_key = dc.category_key
     join dim_category dc2
   on b.category_key = dc2.category_key
),
-- How many these products bought together
-- Detect if they in the same category or not
pair_counts as (
   select -- first_product,
          First_Product_Name,
          Fisrt_Category_Name,
          -- second_product,
          Second_Product_Name,
          Second_Category_Name,
          Relation_Type,
          count(*) as frequency
     from product_pairs
    group by -- first_product,
             First_Product_Name,
             Fisrt_Category_Name,
             -- second_product,
             Second_Product_Name,
             Second_Category_Name,
             Relation_Type
)
select *
  from pair_counts
 order by frequency desc;
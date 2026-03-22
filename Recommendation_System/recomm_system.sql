-- Use ecommerce_Dw;

-- check all products in our business
SELECT 
    f.order_id,
    f.product_key,
    dp.product_name,
    f.category_key,
    dc.category_name,
    f.net_amount,
    dd.full_date
FROM fact_order_line f
JOIN dim_product dp
    ON f.product_key = dp.product_key
JOIN dim_category dc
    ON f.category_key = dc.category_key
JOIN dim_date dd
    ON f.date_key = dd.date_key;


-- check products bought together in the same order
WITH product_pairs AS (
    SELECT 
        a.product_key AS First_Product,
        dp.product_name AS First_Product_Name,
        b.product_key AS Second_Product,
        dp2.product_name AS Second_Product_Name,

        CASE 
            WHEN a.category_key = b.category_key THEN 'Same Category'
            ELSE 'Different Category'
        END AS Relation_Type

    FROM fact_order_line a
    JOIN fact_order_line b
        ON a.order_id = b.order_id
        AND a.product_key < b.product_key
        

    JOIN dim_product dp
        ON a.product_key = dp.product_key
    JOIN dim_product dp2
        ON b.product_key = dp2.product_key
),
-- How many these products bought together
-- Detect if they in the same category or not
pair_counts AS (
    SELECT 
        First_Product,
        First_Product_Name,
        Second_Product,
        Second_Product_Name,
        Relation_Type,
        COUNT(*) AS Frequency
    FROM product_pairs
    GROUP BY 
        First_Product,
        First_Product_Name,
        Second_Product,
        Second_Product_Name,
        Relation_Type
)
SELECT 
    *,
    ROW_NUMBER() OVER (
        PARTITION BY First_Product
        ORDER BY Frequency DESC
    ) AS Rank_Per_Product
FROM pair_counts
ORDER BY Frequency DESC;


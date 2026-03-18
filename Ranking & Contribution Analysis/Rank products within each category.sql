-- 7. Rank products within each category based on revenue performance.

create or replace view products_rank_over_revenue AS
WITH Revenue AS (
    SELECT 
        category_key,
        d.product_key,
        product_name,
        SUM(net_amount) AS total_revenue,
        RANK() OVER (
            PARTITION BY category_key 
            ORDER BY SUM(net_amount) DESC
        ) AS rank_product
    FROM fact_order_line f join dim_product d
    on f.product_key = d.product_key
    GROUP BY category_key, product_key
)

SELECT *
FROM products_rank_over_revenue
ORDER BY d.category_name, r.rank_product;
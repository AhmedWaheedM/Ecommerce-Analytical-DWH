# 14-  Rank customers based on recency of activity

CREATE OR REPLACE VIEW customer_recency_rank AS
	WITH customer_last_order AS (
	SELECT o.customer_key, MAX(d.full_date) AS last_order_date
	FROM fact_order_line o JOIN dim_date d
	ON o.date_key = d.date_key
	GROUP BY o.customer_key
	)

	SELECT customer_key, last_order_date,
		RANK() OVER(ORDER BY last_order_date DESC) AS recency_rank
	FROM customer_last_order
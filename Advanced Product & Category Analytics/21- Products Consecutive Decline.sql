# 21- Identify products experiencing sustained decline across consecutive periods

CREATE OR REPLACE VIEW products_consecutive_decline AS
	WITH monthly_product_revenue AS (
	SELECT o.product_key, d.year, d.month,
		SUM(o.net_amount) AS revenue
	FROM fact_order_line o
	JOIN dim_date d 
		ON o.date_key = d.date_key
	GROUP BY o.product_key, d.year, d.month
	),

	revenue_with_lag AS (
	SELECT product_key, year, month, revenue,
		LAG(revenue) OVER(PARTITION BY product_key ORDER BY year, month) AS prev_revenue
	FROM monthly_product_revenue
	),

	decline_flag AS (
	SELECT *, CASE WHEN revenue < prev_revenue THEN 1
		ELSE 0 END AS is_decline
	FROM revenue_with_lag
	),

	decline_streak_calc AS (
		SELECT *, SUM(is_decline) OVER (PARTITION BY product_key ORDER BY year, month) AS decline_streak
		FROM decline_flag
	)

	SELECT *
	FROM decline_streak_calc
	WHERE decline_streak >= 1;
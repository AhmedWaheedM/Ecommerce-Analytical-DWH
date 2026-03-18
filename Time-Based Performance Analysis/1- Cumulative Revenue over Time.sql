# 1- Produce cumulative revenue over time to understand long-term growth behavior.

CREATE OR REPLACE VIEW cumulative_revenue AS
	SELECT d.full_date AS Date, SUM(o.net_amount) AS "Daily Revenue",
		SUM(SUM(o.net_amount)) OVER (ORDER BY d.full_date) AS "Cumulative Revenue"
	FROM fact_order_line o JOIN dim_date d
	ON o.date_key = d.date_key
	GROUP BY d.full_date
	ORDER BY d.full_date;
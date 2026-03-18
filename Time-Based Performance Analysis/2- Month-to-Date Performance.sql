# 2- Measure Month-to-Date performance to evaluate intra-month trends

CREATE OR REPLACE VIEW MTD_performance AS
	SELECT d.full_date AS Date, d.year, d.month, SUM(o.net_amount) AS "Daily Revenue",
		SUM(SUM(o.net_amount)) OVER (PARTITION BY year, month ORDER BY d.full_date) AS "MTD Revenue"
	FROM fact_order_line o JOIN dim_date d
	ON o.date_key = d.date_key
	GROUP BY d.full_date, d.year, d.month
	ORDER BY d.full_date
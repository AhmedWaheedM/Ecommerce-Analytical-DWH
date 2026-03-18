# 3- Measure Year-to-Date profit to assess annual performance progression

CREATE OR REPLACE VIEW YTD_profit AS
	SELECT d.year, d.month, d.month_name AS "Month Name", SUM(o.profit_amount) AS "Monthly Profit",
		SUM(SUM(o.profit_amount)) OVER (PARTITION BY d.year ORDER BY d.month) AS "YTD Profit"
	FROM fact_order_line o JOIN dim_date d
	ON o.date_key = d.date_key
	GROUP BY d.year, d.month, d.month_name
	ORDER BY d.year, d.month
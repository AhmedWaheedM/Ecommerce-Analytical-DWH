# 10- Rank regions according to profitability

CREATE OR REPLACE VIEW regions_rank AS
	WITH region_profit AS (
	SELECT c.region, SUM(o.profit_amount) AS region_profit
	FROM fact_order_line o JOIN dim_customer c
	ON o.customer_key = c.customer_key
	GROUP BY c.region
	)

	SELECT region, region_profit,
		RANK() OVER(ORDER BY region_profit DESC) AS "Region Rank"
	FROM region_profit
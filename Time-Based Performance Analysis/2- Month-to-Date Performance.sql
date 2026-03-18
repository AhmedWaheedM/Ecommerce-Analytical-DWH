# 2- Measure Month-to-Date performance to evaluate intra-month trends

SELECT full_date AS Date, year, month, SUM(net_amount) AS "Daily Revenue",
    SUM(SUM(net_amount)) OVER (PARTITION BY year, month ORDER BY d.full_date) AS "MTD Revenue"
FROM fact_order_line o JOIN dim_date d
ON o.date_key = d.date_key
GROUP BY full_date, year, month
ORDER BY full_date
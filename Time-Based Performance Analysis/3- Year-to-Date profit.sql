# 3- Measure Year-to-Date profit to assess annual performance progression

SELECT year, month, month_name AS "Month Name", SUM(profit_amount) AS "Monthly Profit",
    SUM(SUM(profit_amount)) OVER (PARTITION BY year ORDER BY month) AS "YTD Profit"
FROM fact_order_line o JOIN dim_date d
ON o.date_key = d.date_key
GROUP BY year, month, month_name
ORDER BY year, month
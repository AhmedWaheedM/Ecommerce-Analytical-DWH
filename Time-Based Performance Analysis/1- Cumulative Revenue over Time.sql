# 1- Produce cumulative revenue over time to understand long-term growth behavior.

SELECT full_date AS Date, SUM(net_amount) AS "Daily Revenue",
    SUM(SUM(net_amount)) OVER (ORDER BY d.full_date) AS "Cumulative Revenue"
FROM fact_order_line o JOIN dim_date d
ON o.date_key = d.date_key
GROUP BY full_date
ORDER BY full_date;
CREATE or REPLACE VIEW daily_net_trend AS
WITH Daily_Net AS (
    SELECT 
        d.full_date, week_number,
        DAYNAME(d.full_date) AS day_name,
        SUM(f.net_amount) AS total_daily_net
    FROM fact_order_line f
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY d.full_date
)
SELECT
    full_date,
    day_name,
    week_number,
    total_daily_net,
    ROUND(
        AVG(total_daily_net) OVER (
            ORDER BY full_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ), 3
    ) AS moving_avg_trend_daily
FROM Daily_Net;
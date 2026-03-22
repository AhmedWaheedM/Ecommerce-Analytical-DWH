# All Queries Documentation

All queries are run through **views** to facilitate the import process in **Power BI**.

---

## A.4. Smooth Short-Term Volatility Using Moving Average Trend Analysis

- Aggregate **daily net revenue**
- Calculate **7-day moving average** for short-term trend

> We can also calculate weekly or yearly aggregates for medium/long-term trends

### Columns Extracted:
- `full_date` → for time series visuals  
- `day_name` → drill-down by weekday  
- `week_number` → drill-up or filter by week  
- `total_daily_net` → raw daily revenue  
- `moving_avg_trend_daily` → smoothed short-term revenue trend  

> According to the **ISO 8601 standard**, the week begins on Monday

---

## B.7. Rank Products Within Each Category Based on Revenue Performance

- Aggregate **revenue per product within its category**
- Rank products using `RANK()` window function partitioned by category

### Columns Extracted:
- `parent_category` → grouping / filtering  
- `category_name` → category label  
- `product_key` → unique product identifier  
- `total_amount` → revenue per product  
- `rank_product` → rank of product inside its category  

---

## B.8. Determine Each Product’s Contribution to Its Category’s Total Revenue

- Aggregate **revenue per product**
- Calculate percentage of total category revenue

### Columns Extracted:
- `parent_category` → grouping  
- `category_name` → category label  
- `product_key` → unique product  
- `product_revenue` → revenue per product  
- `contribution_percentage` → % of category revenue  

---

## C.16. Identify the Top Percentile of High-Value Customers

- Aggregate total revenue per customer (`SUM(net_amount)`)
- Calculate percentile rank using `PERCENT_RANK()`
- Filter top percentile  
- Calculate % contribution to total revenue  

### Columns Extracted:
- `customer_key` → unique identifier  
- `total_revenue` → revenue per customer  
- `percentile_rank` → relative position among all customers  
- `revenue_percentage` → % of total revenue  
- `customer_segment` → “Top 20%” vs “Other”  

---

## D.20. Evaluate Profit Consistency Across Time Periods

- Aggregate profit per chosen time period (daily, weekly, monthly)
- Calculate moving average of profit for trend
- Calculate rolling standard deviation for volatility (profit consistency)

### Columns Extracted:
- `full_date` → x-axis for time  
- `total_profit` → raw profit per period  
- `moving_avg_profit` → smoothed trend  
- `profit_volatility` → rolling profit over past 7 days  

---

## Recommendation System

### Observations:
- Total co-occurring product combinations: **9 only**
- Products are **different**
- Transactions are **not on the same date**
- Products are sold within a time window of **33 months**
 
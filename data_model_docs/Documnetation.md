All queries are executed as **views** to facilitate **reporting and visualization in Power BI**. They cover **product performance, customer behavior, revenue trends, profitability, and regional/brand analysis**.

---

## **A. Short-Term Revenue Trend Analysis**

### **A.1. Smooth Short-Term Volatility Using Moving Average**

**Purpose / Analytical Reasoning:**

- Smooth short-term revenue fluctuations to identify underlying trends.
    
- Enables visualization of short-term trends while filtering out noise.
    

**Steps / Logic:**

1. Aggregate **daily net revenue**.
    
2. Calculate **7-day moving average** to smooth short-term variations.
    

> Weekly or yearly aggregates can also be calculated for medium/long-term trends.

**Columns Extracted:**

|Column|Description|
|---|---|
|full_date|Date for time series visualizations|
|day_name|Drill-down by weekday|
|week_number|Drill-up or filter by week|
|total_daily_net|Raw daily revenue|
|moving_avg_trend_daily|Smoothed short-term revenue trend|

**Notes:**

- ISO 8601 standard is used; week begins on Monday.
    

---

### **A.2. Cumulative Revenue Over Time**

**Purpose / Analytical Reasoning:**

- Track **long-term revenue growth trends**.
    
- Identify seasonal patterns or anomalies.
    

**Steps / Logic:**

1. Aggregate **daily revenue**.
    
2. Compute cumulative using `SUM() OVER (ORDER BY full_date)`.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|Date|Transaction date|
|Daily Revenue|Revenue for the day|
|Cumulative Revenue|Running total revenue|

---

### **A.3. Month-to-Date (MTD) Revenue**

**Purpose / Analytical Reasoning:**

- Monitor **intra-month revenue trends**.
    
- Useful for operational decision-making.
    

**Steps / Logic:**

1. Aggregate **daily revenue per month**.
    
2. Compute **running total per month** using `SUM() OVER (PARTITION BY year, month ORDER BY full_date)`.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|Date|Transaction date|
|Year|Year|
|Month|Month|
|Daily Revenue|Daily revenue|
|MTD Revenue|Month-to-date revenue|

---

### **A.4. Year-to-Date (YTD) Profit**

**Purpose / Analytical Reasoning:**

- Track **annual profit accumulation**.
    
- Supports yearly financial planning.
    

**Steps / Logic:**

1. Aggregate **monthly profit**.
    
2. Compute YTD using `SUM() OVER (PARTITION BY year ORDER BY month)`.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|Year|Transaction year|
|Month|Month number|
|Month Name|Month label|
|Monthly Profit|Profit per month|
|YTD Profit|Year-to-date profit|

---

### **A.5. Month-over-Month (MoM) Revenue Change**

**Purpose / Analytical Reasoning:**

- Compare revenue to previous month to detect growth trends.
    

**Steps / Logic:**

1. Aggregate **monthly revenue**.
    
2. Use `LAG()` to fetch previous month.
    
3. Compute absolute and % change.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|Year|Year|
|Month|Month|
|Month Name|Month label|
|Current Monthly Revenue|Revenue this month|
|Previous Monthly Revenue|Revenue previous month|
|MoM Change|Difference from previous month|
|MoM Percent Change|Percentage change|

---

### **A.6. Revenue Acceleration / Deceleration**

**Purpose / Analytical Reasoning:**

- Identify if revenue growth is **accelerating, decelerating, or stable**.
    

**Steps / Logic:**

1. Compute **monthly growth rate**.
    
2. Calculate acceleration = `current growth − previous growth`.
    
3. Label trend as `accelerating`, `decelerating`, or `stable`.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|Year|Year|
|Month|Month|
|Growth Rate %|MoM growth rate|
|Previous Growth Rate %|Previous month growth|
|Acceleration %|Change in growth rate|
|Dynamics Label|‘Accelerating’, ‘Decelerating’, ‘Stable’|

---

## **B. Product Performance & Category Contribution**

### **B.1. Rank Products Within Each Category Based on Revenue**

**Purpose / Analytical Reasoning:**

- Identify top-performing products within each category.
    
- Useful for prioritizing marketing and inventory planning.
    

**Steps / Logic:**

1. Aggregate **revenue per product within its category**.
    
2. Rank products using `RANK()` window function partitioned by category.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|parent_category|Category grouping for filtering|
|category_name|Category label|
|product_key|Unique product identifier|
|total_amount|Revenue per product|
|rank_product|Rank of product inside its category|

---

### **B.2. Determine Each Product’s Contribution to Category Revenue**

**Purpose / Analytical Reasoning:**

- Quantify each product’s share of its category’s total revenue.
    
- Identifies high-impact products contributing the most revenue.
    

**Steps / Logic:**

1. Aggregate **revenue per product**.
    
2. Calculate **percentage of total category revenue**.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|parent_category|Category grouping|
|category_name|Category label|
|product_key|Unique product identifier|
|product_revenue|Revenue per product|
|contribution_percentage|% of category revenue|

---

### **B.3. High-Impact Products (Pareto Analysis)**

**Purpose / Analytical Reasoning:**

- Identify products contributing **most revenue (80/20 rule)**.
    
- Supports inventory planning and sales strategy focus.
    

**Steps / Logic:**

1. Aggregate **total revenue per product**.
    
2. Compute **cumulative revenue %**.
    
3. Flag top 80% cumulative revenue products as high-impact.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|product_key|Unique product identifier|
|total_revenue|Revenue generated by product|
|cumulative_pct|Running total % of revenue|
|is_high_impact|Flag: 1 = high, 0 = low|
|pareto_label|‘High impact’ / ‘Low impact’|

---

### **B.4. Rank Regions According to Profitability**

**Purpose / Analytical Reasoning:**

- Evaluate **regional performance** by profit.
    
- Guides marketing, investment, and resource allocation.
    

**Steps / Logic:**

1. Aggregate **profit per region**.
    
2. Rank regions using `RANK()` descending.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|region|Region name|
|region_profit|Total profit|
|Region Rank|Rank based on descending profit|

---

### **B.5. Rank Brands Within Each Category**

**Purpose / Analytical Reasoning:**

- Identify **top brands within each category** by profit.
    
- Supports brand-level strategy and category management.
    

**Steps / Logic:**

1. Aggregate **profit per brand within category**.
    
2. Use `DENSE_RANK()` to assign rank per category.
    

**Columns Extracted:**

|Column|Description|
|---|---|
|category_name|Category label|
|brand|Brand name|
|total_profit|Profit generated by brand|
|brand_rank|Rank of brand within category|

---

## **C. Customer Analysis**

### **C.1. Cumulative Customer Spend**

**Purpose / Analytical Reasoning:**

- Track total spending of each customer over time (Customer Lifetime Value - CLV).
    
- Useful for identifying high-value customers and loyalty trends.
    

**Steps / Logic:**

1. Aggregate each order’s net amount per customer and order date.
    
2. Use a window function `SUM() OVER (PARTITION BY customer_id ORDER BY full_date, order_id)` to compute **running total spend**.
    

**Columns Extracted:**

- `customer_id` – Unique customer identifier
    
- `full_date` – Date of the order
    
- `order_id` – Unique order identifier
    
- `order_amount` – Revenue of that order
    
- `cumulative_spend` – Running total spend per customer
    


---

### **C.2. Days Between Orders (Purchase Frequency)**

**Purpose / Analytical Reasoning:**

- Calculate the time gap between consecutive orders per customer.
    
- Helps identify buying frequency, potential churn, or engagement opportunities.
    

**Steps / Logic:**

1. Extract distinct orders per customer with order date.
    
2. Use `LAG()` to fetch previous order date.
    
3. Compute `DATEDIFF()` between current and previous orders.
    

**Columns Extracted:**

- `customer_id` – Unique customer identifier
    
- `order_id` – Unique order identifier
    
- `current_order_date` – Date of the current order
    
- `previous_order_date` – Date of previous order
    
- `days_between_orders` – Number of days since previous order
    


---

### **C.3. Customer Recency Ranking**

**Purpose / Analytical Reasoning:**

- Rank customers based on how recently they placed an order.
    
- Supports marketing prioritization (targeting most recent vs inactive customers).
    

**Steps / Logic:**

1. Identify the latest order date for each customer.
    
2. Use `RANK() OVER(ORDER BY last_order_date DESC)` to assign ranks (1 = most recent).
    

**Columns Extracted:**

- `customer_key` – Unique customer identifier
    
- `last_order_date` – Most recent order date
    
- `recency_rank` – Rank based on recency
    


---

### **C.4. Customer Spending Tiers (Quartiles)**

**Purpose / Analytical Reasoning:**

- Segment customers into spending tiers (low, mid, high, top).
    
- Supports loyalty programs, marketing segmentation, and engagement strategies.
    

**Steps / Logic:**

1. Aggregate total spending per customer.
    
2. Use `NTILE(4)` to divide customers into quartiles.
    
3. Assign descriptive labels for tiers.
    

**Columns Extracted:**

- `customer_id` – Unique customer identifier
    
- `total_spending` – Total revenue per customer
    
- `quartile` – Quartile number (1–4)
    
- `spending_tier` – Label for quartile: low/mid/high/top spender
    


---

### **C.5. High-Value Customer Identification (Top Percentile)**

**Purpose / Analytical Reasoning:**

- Identify the top 20% of customers by revenue contribution.
    
- Useful for targeting high-value customers in marketing and loyalty programs.
    

**Steps / Logic:**

1. Aggregate total revenue per customer.
    
2. Calculate percentile rank using `PERCENT_RANK()`.
    
3. Label customers in the top 20% as high-value.
    

**Columns Extracted:**

- `customer_key` – Unique customer identifier
    
- `total_revenue` – Revenue per customer
    
- `percentile_rank` – Customer rank percentile
    
- `high_customers` – Flag: 'Top 20%' or 'Other'
    


---

## **D. Advanced Product & Category Analytics**
### **D.1. Assess Revenue Volatility for Each Product**

**Purpose / Analytical Reasoning:**

- Measure the stability of revenue per product.
    
- Identify products with consistent, moderate, or highly volatile revenue.
    
- Helps inform inventory management, marketing, and risk assessment.
    

**Steps / Logic:**

1. Aggregate **monthly revenue per product**.
    
2. Calculate **average monthly revenue** and **standard deviation** per product.
    
3. Compute **coefficient of variation (CV)** = `(stddev / avg) × 100`.
    
4. Categorize products into: `'stable'`, `'moderate'`, `'highly volatile'`.
    
5. Rank products by volatility.
    

**Columns Extracted:**

- `product_key` – Unique product identifier
    
- `months_active` – Number of months with sales
    
- `avg_monthly_revenue` – Average monthly revenue
    
- `revenue_stddev` – Standard deviation of monthly revenue
    
- `volatility_pct` – Coefficient of variation (%)
    
- `volatility_label` – Volatility category
    
- `volatility_rank` – Rank by volatility
    

---

### **D.2. Detect Trending Categories**

**Purpose / Analytical Reasoning:**

- Identify categories with upward or downward trends relative to historical performance.
    
- Useful for category-level strategy and inventory adjustments.
    

**Steps / Logic:**

1. Aggregate **monthly revenue per category**.
    
2. Compute **recent 3-month average** and **historical average**.
    
3. Compare recent vs historical averages:
    
    - `recent_avg > historical_avg → trending up`
        
    - `recent_avg < historical_avg → trending down`
        
4. Calculate **trend percentage** for magnitude.
    

**Columns Extracted:**

- `category_name` – Category label
    
- `category_key` – Unique category identifier
    
- `historical_avg` – Average monthly revenue historically
    
- `recent_3m_avg` – Average revenue over last 3 months
    
- `trend_pct` – Percentage change `(recent - historical)/historical × 100`
    
- `trend_status` – `'trending up'` or `'trending down'`
    

---

### **D.3. Year-over-Year (YoY) Revenue Comparison**

**Purpose / Analytical Reasoning:**

- Compare revenue for the same month across consecutive years.
    
- Detect seasonal patterns, growth, and anomalies.
    

**Steps / Logic:**

1. Aggregate **monthly revenue**.
    
2. Use `LAG()` to fetch **previous year’s revenue** for the same month.
    
3. Compute **YoY change** (`current - previous`) and **YoY percent change**.
    

**Columns Extracted:**

- `year` – Current year
    
- `month` – Month number
    
- `month_name` – Month name
    
- `current_year_revenue` – Revenue for current month
    
- `previous_year_revenue` – Revenue for same month previous year
    
- `yoy_change` – Absolute revenue change
    
- `yoy_percent_change` – Percentage revenue change
    

---

### **D.4. Evaluate Profit Consistency Across Time Periods**

**Purpose / Analytical Reasoning:**

- Measure **stability of profit over time**.
    
- Detect high fluctuations and trends.
    

**Steps / Logic:**

1. Aggregate **daily profit** (optionally include discounts).
    
2. Compute **moving average** over the last 7 days for trend smoothing.
    
3. Compute **rolling standard deviation** for profit volatility.
    

**Columns Extracted:**

- `full_date` – Date
    
- `week_number` – Week number (ISO standard)
    
- `total_daily_profit` – Daily profit
    
- `moving_avg_profit` – 7-day moving average profit
    
- `profit_volatility` – 7-day rolling standard deviation
    

---

### **D.5. Identify Products with Sustained Decline Across Consecutive Periods**

**Purpose / Analytical Reasoning:**

- Detect products whose revenue is declining over consecutive months.
    
- Supports proactive inventory, marketing, and product lifecycle decisions.
    

**Steps / Logic:**

1. Aggregate **monthly revenue per product**.
    
2. Use `LAG()` to fetch **previous month revenue**.
    
3. Flag months where revenue < previous month.
    
4. Compute **decline streak** using a running sum.
    
5. Filter products with decline streak ≥ 1 to focus on sustained decline.
    

**Columns Extracted:**

- `product_key` – Unique product identifier
    
- `year` – Year
    
- `month` – Month
    
- `revenue` – Revenue for the month
    
- `prev_revenue` – Revenue of previous month
    
- `is_decline` – 1 = revenue declined, 0 = no decline
    
- `decline_streak` – Count of consecutive decline periods
    

---

## **Recommendation System**

**Purpose / Analytical Reasoning:**

- Generate product recommendations based on co-purchase patterns, product recency, category trends, volatility, revenue rank, Pareto impact, and stock availability.
    
- Designed for cross-selling and upselling strategies.
    
- Scores products for recommendation to highlight the most relevant ones for a selected main product.
    

---

### **Prerequisites / Dependencies**

Before running this query, make sure these views exist and are up-to-date:

1. `vw_product_revenue_rank` (Q7) → Product revenue rankings
    
2. `vw_pareto` (Q9) → High-impact Pareto products
    
3. `vw_product_volatility` (Q17) → Product revenue volatility
    
4. `vw_category_trend` (Q18) → Category performance trends
    

---

### **Step 1 — Identify Co-Purchased Products (`co_purchase`)**

- For each main product, find all products purchased **in the same order**, excluding itself.
    
- Count the frequency of co-purchases to gauge product affinity.
    

**Columns:**

- `main_product_key` → Product in focus
    
- `co_product_key` → Co-purchased product
    
- `co_product_name` → Name of co-purchased product
    
- `co_purchase_freq` → Number of times the products were bought together
    

---

### **Step 2 — Recency of Co-Purchase (`recency`)**

- Calculate how recently the main product was co-purchased with each co-product.
    
- Uses `DATEDIFF(CURDATE(), last_purchase_date)` to measure recency.
    

**Columns:**

- `main_product_key`
    
- `co_product_key`
    
- `days_since_last_co_purchase` → Smaller values = more recent
    

---

### **Step 3 — Scoring Metrics (`scoring`)**

Combine multiple dimensions into normalized scores for each co-product:

1. **Normalized Co-Purchase Frequency** → How frequently products are bought together.
    
2. **Normalized Recency** → More recent co-purchases score higher.
    
3. **Normalized Category Trend** → Categories trending up get a score of 1.
    
4. **Normalized Stability (Volatility)** → Stable products are preferred.
    
5. **Normalized Category Rank** → Higher revenue-ranked products score better.
    
6. **Normalized Pareto / High-Impact** → Top 20% products get higher score.
    
7. **Normalized Stock Availability** → Products in stock are favored.
    

**Columns included:**

- `main_product_key`, `co_product_key`, `co_product_name`
    
- `co_purchase_freq`, `days_since_last_co_purchase`
    
- `volatility_pct`, `rank_in_category`, `is_high_impact`, `stock_available`
    
- `norm_co_purchase`, `norm_recency`, `norm_category_trend`, `norm_stability`, `norm_category_rank`, `norm_pareto`, `norm_stock`
    

---

### **Step 4 — Calculate Final Recommendation Score**

Weighted aggregation of normalized metrics:

|Metric|Weight|
|---|---|
|Co-purchase frequency|25%|
|Recency|20%|
|Category trend|15%|
|Volatility (stability)|15%|
|Category rank|10%|
|Pareto impact|10%|
|Stock availability|5%|

**Formula (simplified):**

```
recommendation_score = 
    (norm_co_purchase * 0.25) +
    (norm_recency * 0.20) +
    (norm_category_trend * 0.15) +
    (norm_stability * 0.15) +
    (norm_category_rank * 0.10) +
    (norm_pareto * 0.10) +
    (norm_stock * 0.05)
```

- Outputs a **score between 0 and 1** (rounded to 4 decimals).
    
- Higher scores indicate stronger recommendations.
    

---

### **Final Output Columns**

- `main_product_key` → Selected product
    
- `co_product_key` → Recommended co-product
    
- `co_product_name` → Name of recommended product
    
- `co_purchase_freq` → Historical co-purchase frequency
    
- `days_since_last_co_purchase` → Recency metric
    
- `volatility_pct` → Product revenue volatility
    
- `rank_in_category` → Product revenue rank within category
    
- `is_high_impact` → Pareto top product
    
- `stock_available` → Current stock level
    
- `category_trend` → `'trending up'` or `'trending down'`
    
- `recommendation_score` → Weighted score for ranking recommendations
    

---







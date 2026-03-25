-- Prerequisites — run these files first:
--   Q7 -> vw_product_revenue_rank
--   Q9 -> vw_pareto
--   Q17 -> vw_product_volatility
--   Q18 -> vw_category_trend

set @selected_product = 'nike air max 270';

with

-- find products frequently bought together with the selected product
co_purchase as (
    select b.product_key, dp.product_name, count(*) as co_purchase_freq
    from fact_order_line a
    join fact_order_line b on a.order_id = b.order_id and a.product_key != b.product_key
    join dim_product dp on b.product_key = dp.product_key
    where a.product_key = (select product_key from dim_product where product_name = @selected_product limit 1)
    group by b.product_key, dp.product_name
),

-- calculate how recently each product was co-purchased
recency as (
    select b.product_key, datediff(curdate(), max(d.full_date)) as days_since_last_co_purchase
    from fact_order_line a
    join fact_order_line b on a.order_id = b.order_id and a.product_key != b.product_key
    join dim_date d on a.date_key = d.date_key
    where a.product_key = (select product_key from dim_product where product_name = @selected_product limit 1)
    group by b.product_key
),

-- combine all features and normalize signals between 0 and 1
scoring as (
    select cp.product_key, cp.product_name, cp.co_purchase_freq, r.days_since_last_co_purchase,
           ct.recent_3m_avg, ct.historical_avg, v.volatility_pct, cr.rank_in_category,
           p.is_high_impact, dp.stock_available,
           round(cp.co_purchase_freq / nullif(max(cp.co_purchase_freq) over (), 0), 4) as norm_co_purchase,
           round(1 - (r.days_since_last_co_purchase / nullif(max(r.days_since_last_co_purchase) over (), 0)), 4) as norm_recency,
           round(case when ct.recent_3m_avg > ct.historical_avg then 1 else 0 end, 4) as norm_category_trend,
           round(1 - (v.volatility_pct / nullif(max(v.volatility_pct) over (), 0)), 4) as norm_stability,
           round(1 - (cr.rank_in_category / nullif(max(cr.rank_in_category) over (), 0)), 4) as norm_category_rank,
           round(p.is_high_impact, 4) as norm_pareto,
           round(dp.stock_available / nullif(max(dp.stock_available) over (), 0), 4) as norm_stock
    from co_purchase cp
    join recency r on cp.product_key = r.product_key
    join dim_product dp on cp.product_key = dp.product_key
    join (select distinct product_key, category_key from fact_order_line) fk on cp.product_key = fk.product_key
    join vw_category_trend ct on fk.category_key = ct.category_key
    join vw_product_volatility v on cp.product_key = v.product_key
    join vw_product_revenue_rank cr on cp.product_key = cr.product_key
    join vw_pareto p on cp.product_key = p.product_key
)

-- calculate weighted score and return top recommendations
select product_name, co_purchase_freq, days_since_last_co_purchase, volatility_pct,
       rank_in_category, is_high_impact, stock_available,
       case when recent_3m_avg > historical_avg then 'trending up' else 'trending down' end as category_trend,
       round((norm_co_purchase * 0.25) + (norm_recency * 0.20) + (norm_category_trend * 0.15) + (norm_stability * 0.15) 
       + (norm_category_rank * 0.10) + (norm_pareto * 0.10) + (norm_stock * 0.05), 4) as recommendation_score
from scoring
order by recommendation_score desc
limit 4;
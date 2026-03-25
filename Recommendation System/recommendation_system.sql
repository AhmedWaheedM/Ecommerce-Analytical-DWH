-- prerequisites:
--   q7 -> vw_product_revenue_rank
--   q9 -> vw_pareto
--   q17 -> vw_product_volatility
--   q18 -> vw_category_trend

create or replace view recommendation_system as
with

-- find products frequently bought together (co-purchase frequency)
co_purchase as (
    select a.product_key as main_product_key,
           b.product_key as co_product_key,
           dp.product_name as co_product_name,
           count(*) as co_purchase_freq
    from fact_order_line a
    join fact_order_line b 
      on a.order_id = b.order_id 
     and a.product_key != b.product_key
    join dim_product dp on b.product_key = dp.product_key
    group by a.product_key, b.product_key, dp.product_name
),

-- measure recency of co-purchases (how recent the relationship is)
recency as (
    select a.product_key as main_product_key,
           b.product_key as co_product_key,
           datediff(curdate(), max(d.full_date)) as days_since_last_co_purchase
    from fact_order_line a
    join fact_order_line b 
      on a.order_id = b.order_id 
     and a.product_key != b.product_key
    join dim_date d on a.date_key = d.date_key
    group by a.product_key, b.product_key
),

-- combine all signals and normalize them per main product
scoring as (
    select cp.main_product_key, cp.co_product_key, cp.co_product_name,
           cp.co_purchase_freq, r.days_since_last_co_purchase,
           ct.recent_3m_avg, ct.historical_avg,
           v.volatility_pct, cr.rank_in_category,
           p.is_high_impact, dp.stock_available,

           -- normalization ensures fair comparison within each main product group
           round(cp.co_purchase_freq / nullif(max(cp.co_purchase_freq) over (partition by cp.main_product_key), 0), 4) as norm_co_purchase,
           round(1 - (r.days_since_last_co_purchase / nullif(max(r.days_since_last_co_purchase) over (partition by cp.main_product_key), 0)), 4) as norm_recency,
           round(case when ct.recent_3m_avg > ct.historical_avg then 1 else 0 end, 4) as norm_category_trend,
           round(1 - (v.volatility_pct / nullif(max(v.volatility_pct) over (partition by cp.main_product_key), 0)), 4) as norm_stability,
           round(1 - (cr.rank_in_category / nullif(max(cr.rank_in_category) over (partition by cp.main_product_key), 0)), 4) as norm_category_rank,
           round(p.is_high_impact, 4) as norm_pareto,
           round(dp.stock_available / nullif(max(dp.stock_available) over (partition by cp.main_product_key), 0), 4) as norm_stock
    from co_purchase cp
    join recency r 
      on cp.main_product_key = r.main_product_key 
     and cp.co_product_key = r.co_product_key
    join dim_product dp on cp.co_product_key = dp.product_key
    join (select distinct product_key, category_key from fact_order_line) fk 
      on cp.co_product_key = fk.product_key
    join vw_category_trend ct on fk.category_key = ct.category_key
    join vw_product_volatility v on cp.co_product_key = v.product_key
    join vw_product_revenue_rank cr on cp.co_product_key = cr.product_key
    join vw_pareto p on cp.co_product_key = p.product_key
)

-- compute final weighted recommendation score
select main_product_key, co_product_key, co_product_name,
       co_purchase_freq, days_since_last_co_purchase,
       volatility_pct, rank_in_category, is_high_impact, stock_available,
       case when recent_3m_avg > historical_avg then 'trending up' else 'trending down' end as category_trend,
       round(
           (norm_co_purchase * 0.25) +
           (norm_recency * 0.20) +
           (norm_category_trend * 0.15) +
           (norm_stability * 0.15) +
           (norm_category_rank * 0.10) +
           (norm_pareto * 0.10) +
           (norm_stock * 0.05),
       4) as recommendation_score
from scoring;

-- get top 4 recommendations for a specific product
select *
from recommendation_system
where main_product_key = (
    select product_key
    from dim_product
    where product_name = 'nike air max 270'
    limit 1
)
order by recommendation_score desc
limit 4;
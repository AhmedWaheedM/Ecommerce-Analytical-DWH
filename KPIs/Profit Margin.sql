-- kpi 6: profit margin
select sum(net_amount) as total_revenue, sum(profit_amount) as total_profit,
       round(sum(profit_amount) / nullif(sum(net_amount), 0) * 100, 2) as profit_margin_pct
from fact_order_line;

-- profit margin per month
select d.year, d.month, d.month_name,
       round(sum(f.net_amount), 2) as monthly_revenue,
       round(sum(f.profit_amount), 2) as monthly_profit,
       round(sum(f.profit_amount) / nullif(sum(f.net_amount), 0) * 100, 2) as profit_margin_pct
from fact_order_line f
join dim_date d on f.date_key = d.date_key
group by d.year, d.month, d.month_name
order by d.year, d.month;
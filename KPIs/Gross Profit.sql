-- kpi 2: gross profit (revenue - cost)
select sum(net_amount) as total_revenue, sum(cost_amount) as total_cost,
       sum(net_amount) - sum(cost_amount) as gross_profit
from fact_order_line;

-- monthly gross profit breakdown
select d.year, d.month, d.month_name, sum(f.net_amount) as monthly_revenue,
       sum(f.cost_amount) as monthly_cost,
       sum(f.net_amount) - sum(f.cost_amount) as gross_profit
from fact_order_line f
join dim_date d on f.date_key = d.date_key
group by d.year, d.month, d.month_name
order by d.year, d.month;
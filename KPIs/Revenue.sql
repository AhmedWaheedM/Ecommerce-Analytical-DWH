-- kpi 1: revenue (total net sales)
select sum(net_amount) as total_revenue
from fact_order_line;

-- revenue by month for trend analysis
select d.year, d.month, d.month_name, sum(f.net_amount) as monthly_revenue
from fact_order_line f
join dim_date d on f.date_key = d.date_key
group by d.year, d.month, d.month_name
order by d.year, d.month;

-- 16. Identify the top percentile of high-value customers. 

create or replace view high_value_customers as
   with customer_revenue as (
      select f.customer_key,
             gender,
             age_group,
             customer_segment,
             sum(net_amount) as total_revenue
        from fact_order_line f
        join dim_customer d
      on f.customer_key = d.customer_key
       group by customer_key
   ),ranked_customers as (
      select customer_key,
             total_revenue,
             gender,
             age_group,
             customer_segment,
             percent_rank()
             over(
                 order by total_revenue
             ) as percentile_rank
        from customer_revenue
   )
   select customer_key,
          total_revenue,
          gender,
          age_group,
          customer_segment,
          percentile_rank
     from ranked_customers;


select *,
       round(
          percentile_rank * 100,
          0
       ) as percentile_rank,
       case
          when percentile_rank >= 0.8 then
             'Top 20%'
          else
             'Other'
       end as high_customers
  from high_value_customers
 order by total_revenue desc;
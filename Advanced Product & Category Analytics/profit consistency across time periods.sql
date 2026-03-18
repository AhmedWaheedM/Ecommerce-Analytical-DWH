-- 20. Evaluate profit consistency across time periods.

create or replace view profit_consistency as
   with daily_profit as (
      select d.full_date,
             d.week_number,
             sum(f.discount_amount) as total_discount,
             sum(f.profit_amount) as total_daily_profit
        from fact_order_line f
        join dim_date d
      on f.date_key = d.date_key
       group by d.full_date,
                d.week_number
   )
   
   select *,
          round(
             avg(total_daily_profit)
             over(
                 order by full_date
                rows between 6 preceding and current row
             ),
             2
          ) as moving_avg_profit,
          round(
             stddev_samp(total_daily_profit)
             over(
                 order by full_date
                rows between 6 preceding and current row
             ),
             2
          ) as profit_volatility
     from profit_consistency
    order by full_date;
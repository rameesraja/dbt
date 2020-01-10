select 
month(order_date) as month, year(order_date) as year,sum(case when status = 'returned' then 1 else 0 end ) as No_Returned


from {{ ref("orders")}}
group by month, year




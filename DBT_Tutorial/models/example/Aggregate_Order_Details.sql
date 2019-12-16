{{config (materialized = 'view')}}

with cte as
(
SELECT Sum(User_ID) NumberOfOrders,User_ID
FROM  raw_orders R
GROUP BY User_ID
)
select c.NumberOfOrders,r.first_name,r.last_name
from cte c join raw_customers r
on c.User_ID = r.id


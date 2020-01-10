{{ config(severity='warn') }}

with status as
( select 
case when status='returned' then 1 else 0 end as returned,
case when status='placed' then 1 else 0  end as placed
from {{ ref('stg_orders') }}
),
val as (
select (sum(returned)/sum(placed)) * 100 as pct from status)

select * from val where pct >= 35

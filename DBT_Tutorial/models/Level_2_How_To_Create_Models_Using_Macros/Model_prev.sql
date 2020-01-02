{{ config(materialized='view') }}
select {{ConIntVar('ID')}}
from raw_payments
{{ config(materialized='table') }}
select {{ ConIntVar('ID') }}
from raw_payments
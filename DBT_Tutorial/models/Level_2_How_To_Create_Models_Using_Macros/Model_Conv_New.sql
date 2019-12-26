{{ config(materialized='table') }}
select {{ ConIntVar('ID') }}
from TT
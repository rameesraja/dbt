{{ config(materialized='view') }}
select {{ConIntVar('ID')}}
from TT
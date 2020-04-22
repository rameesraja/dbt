

{{ config(
    materialized='table',
    database='dbt_training_1',
    schema='jiwon',
    alias ='myTable',
    enabled =false
)}}

select 1 as dummy
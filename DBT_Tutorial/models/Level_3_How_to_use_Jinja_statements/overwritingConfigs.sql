{{ config(materialized='table') }}
{{ config(database='DBT_WORKSHOP_BATCH_1') }}
{{ config(schema='SHAHUL') }}

select 1 as dummy
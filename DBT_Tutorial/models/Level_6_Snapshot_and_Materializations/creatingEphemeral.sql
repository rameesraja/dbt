{{ config(
    materialized='ephemeral'
)

}}


select * from raw_customers limit 100
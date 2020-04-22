{{
    config(
        materialized='incremental'
        
    )
}}

select * from raw_orders
{% if is_incremental() %}

where order_date > (select max(order_date) from {{ this }})

{% endif %}
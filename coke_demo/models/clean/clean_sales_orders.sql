{{
    config
    (
        materialized = 'incremental',
        tags = ['sales']

    )
    
}}

select
    id as order_id,
    upper(material) as material_name,
    upper(customer) as customer_name,
    sales_time as sales_at,
    order_qty as sales_order_quantity
from {{ ref('stg_sales_orders') }}

{% if is_incremental() %}

where sales_time > ( select max(sales_at) from {{this}} )

{% endif %}
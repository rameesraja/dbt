{{
    config(
        materialized = 'incremental',
        unique_key = 'customer_id',
        tags = ['sales']
    )
}}


select 
    customer_id,
    customer_name,
    customer_city,
    created_at,
    updated_at
from {{ ref('clean_customers')}}

{% if is_incremental() %}

where updated_at > ( select max(updated_at) from {{this}} )

{% endif %}
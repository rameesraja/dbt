{{
    config(
        materialized = 'incremental',
        tags = ['sales']
    )
}}


select 
    id as customer_id,
    upper(name) as customer_name,
    upper(city) as customer_city,
    created_on as created_at,
    updated_on as updated_at
from {{ ref('stg_customers')}}

{% if is_incremental() %}

where updated_on > ( select max(updated_at) from {{this}} )

{% endif %}
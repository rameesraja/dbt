{{
    config
    (
        materialized = 'incremental',
        tags = ['sales','manu']

    )
    
}}

select
    id as material_id,
    upper(name) as material_name,
    price as material_price,
    created_on as created_at,
    updated_on as updated_at
from {{ ref('stg_materials') }}

{% if is_incremental() %}

where updated_on > ( select max(updated_at) from {{this}} )

{% endif %}
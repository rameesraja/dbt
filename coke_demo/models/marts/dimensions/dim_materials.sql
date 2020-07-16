{{
    config
    (
        materialized = 'incremental',
        unique_key = ['material_id','material_name'],
        tags = ['sales','manu']
    )
    
}}

select
    material_id,
    material_name,
    material_price,
    created_at,
    updated_at
from {{ ref('clean_materials') }}

{% if is_incremental() %}

where updated_at > ( select max(updated_at) from {{this}} )

{% endif %}
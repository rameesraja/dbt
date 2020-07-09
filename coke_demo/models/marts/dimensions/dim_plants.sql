{{
    config
    (
        materialized = 'incremental',
        unique_key = 'plant_id',
        tags = ['manu']

    )
    
}}

select
    plant_id,
    plant_name,
    plant_location,
    created_at,
    updated_at
from {{ ref('clean_plants') }}

{% if is_incremental() %}

where updated_at > ( select max(updated_at) from {{this}} )

{% endif %}
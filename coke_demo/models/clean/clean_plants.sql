{{
    config
    (
        materialized = 'incremental',
        tags = ['manu']

    )
    
}}

select
    id as plant_id,
    upper(name) as plant_name,
    upper(city) as plant_location,
    created_on as created_at,
    updated_on as updated_at
from {{ ref('stg_plants') }}

{% if is_incremental() %}

where updated_on > ( select max(updated_at) from {{this}} )

{% endif %}
{{
    config
    (
        materialized = 'incremental',
         tags = ['manu']

    )
    
}}

select
    date as manufactured_at,
    upper(material) as material_name,
    upper(plant) as plant_name,
    qty as manufactured_quantity
from {{ ref('stg_manufacturing') }}

{% if is_incremental() %}

where date > ( select max(manufactured_at) from {{this}} )

{% endif %}
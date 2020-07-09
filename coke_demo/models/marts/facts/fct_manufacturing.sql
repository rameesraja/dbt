{{
    config
    (
        materialized = 'incremental',
        tags = ['manu']

    )
    
}}

with manufacturing as (


    select
        manufactured_at,
        material_name,
        plant_name,
        manufactured_quantity
    from {{ ref('clean_manufaturing') }}

    {% if is_incremental() %}

    where manufactured_at > ( select max(manufactured_at) from {{this}} )

    {% endif %}

),

materials as (

    select * from {{ ref('dim_materials') }}

),

plants as (

    select * from {{ ref('dim_plants') }}

)

select 
    manufactured_at,
    plant_id,
    material_id,
    manufactured_quantity
from manufacturing
join materials on manufacturing.material_name = materials.material_name
join plants on manufacturing.plant_name = plants.plant_name

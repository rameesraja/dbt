{{
    config
    (
        materialized = 'incremental',
        tags = ['sales']

    )
    
}}

with sales_order as (   


    select
        order_id,
        material_name,
        customer_name,
        sales_at,
        sales_order_quantity
    from {{ ref('clean_sales_orders') }}

    {% if is_incremental() %}

    where sales_at > ( select max(sales_at) from {{this}} )

    {% endif %}

),

materials as (

    select * from {{ ref('dim_materials') }}

),

customers as (

    select * from {{ ref('dim_customers') }}

)

select 
    order_id,
    material_id,
    customer_id,
    sales_at,
    sales_order_quantity,
    sales_order_quantity * material_price as sales_price
from sales_order 
join materials on materials.material_name = sales_order.material_name
join customers on customers.customer_name = sales_order.customer_name

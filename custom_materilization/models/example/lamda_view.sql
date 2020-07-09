{{
    config(

        materialized= 'view'
    )    
}}

with source as (
select * from {{ ref('stg_table')}}
{{ apply_lamda_filter('event_time',ref('current_table')) }}

),

new_current as (

    {{ remove_latest_current('id','source',ref('current_table')) }}

),

final as (

    {{ apply_lamda_union('new_current','source') }}

)

select * from final

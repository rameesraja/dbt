{% macro apply_lamda_filter(t,ref) %}

where event_time > ( select max(event_time) from {{ref}} )

{% endmacro %}


{% macro remove_latest_current(key,source,ref) %}

select * from {{ ref }} where {{key}} not in (

    select {{key}} from source
)

{% endmacro %}

{% macro apply_lamda_union(table1,table2) %}

select * from {{ table1 }}

union all 

select * from {{ table2 }}

{% endmacro %}

{% macro UsingStatements() %}

{% call statement('orders',fetch_result=True) %}

select * from raw_orders limit 2
{% endcall %}


{% set ord = load_result('orders') %}
{% set ord_data = ord['data'] %}
{% set ord_status = ord['status'] %}

{{ log(ord_data,True) }}

{% endmacro %}
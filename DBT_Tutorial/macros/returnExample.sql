{% macro returnExample() %}

{% set result = run_query('select distinct payment_method from raw_payments') %}
{% if execute %}
{% set payment_methods = result.columns[0].values() %}
{% endif %}

{{return (payment_methods)}}

{% endmacro %}
{% macro callProcedure() %}
{% set SQL_QRY %}
call testProcedure()
{% endset %}
{% do run_query(SQL_QRY) %}
{{ log("Inside Macro", True) }}
{% endmacro %}
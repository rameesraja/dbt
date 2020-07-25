{% macro test_macro() %}


{% set val = ['col1','col2'] %}

{% set uval = [] %}

{% for v in val %}

    {% do uval.append(v.upper()) %}
{% endfor %}

{{ log(uval, True)}}


{% endmacro %}
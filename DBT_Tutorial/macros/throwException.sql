{% macro throwException(n) %}
{% if n < 0 or n > 100 %}
{{ exceptions.raise_compiler_error("Invalid number:" ~ n) }}
{% endif %}
{% endmacro %}
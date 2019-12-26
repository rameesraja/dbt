{% macro printFlags() %}

{{ log("is full refresh:" ~ flags.FULL_REFRESH,True) }}
{{ log("is full refresh:" ~ flags.STRICT_MODE,True) }}

{% endmacro %}
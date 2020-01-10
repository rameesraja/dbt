{% macro printFlags() %}

{{ log("is full refresh:" ~ flags.FULL_REFRESH,True) }}
{{ log("is strict refresh:" ~ flags.STRICT_MODE,True) }}

{% endmacro %}
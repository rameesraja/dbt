{% macro OrdersBTWMonths(fromdate,todate) %}

where Order_date between '{{- fromdate }}' and '{{- todate }}'

{% endmacro %}
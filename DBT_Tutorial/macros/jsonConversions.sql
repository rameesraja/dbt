{% macro jsonConversions() %}

{% set  my_json = '{"name":"Ramees","city":"Chennai"}' %}

{%set my_list = fromjson(my_json) %}
{% do log(my_list['name'],True) %}

{% set  my_list = '["apple", "banana", "cherry"]' %}

{%set to_json = tojson(my_list) %}
{% do log(to_json,True) %}


{% set my_dict = {"abc": 123} %}
{% set my_json_string = tojson(my_dict) %}

{% do log(my_json_string,True) %}

{% endmacro %}
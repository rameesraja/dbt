{% macro common_get_merge_sql(target, source, unique_key, dest_columns) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute="name") | join(', ') -%}
    {%- set on_clause = [] -%}
    {{ log("In new macro",True) }}
    merge into {{ target }} as DBT_INTERNAL_DEST
    using {{ source }} as DBT_INTERNAL_SOURCE

    {%- if unique_key %}
        {%- for key in unique_key -%}
            {%- set unique_key_match -%}
                DBT_INTERNAL_SOURCE.{{ key }} = DBT_INTERNAL_DEST.{{ key }}
            {%- endset -%}
            {%- do on_clause.append(unique_key_match) %}
        {%- endfor -%}
    {% else %}
        {% do on_clause.append('FALSE') %}
    {%- endif %}

    on {{ on_clause | join(' and ') -}}

    {% if unique_key %}
    when matched then update set
        {% for column in dest_columns -%}
            {{ column.name }} = DBT_INTERNAL_SOURCE.{{ column.name }}
            {%- if not loop.last %}, {%- endif %}
        {%- endfor %}
    {% endif %}

    when not matched then insert
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv }})

{%- endmacro %}
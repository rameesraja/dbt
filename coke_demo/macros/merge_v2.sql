{% macro get_merge_sql_v2(target, source, unique_key, dest_columns, predicates, non_update_columns, matched_predicates) -%}
  {{ adapter_macro('get_merge_sql_v2', target, source, unique_key, dest_columns, predicates, non_update_columns, matched_predicates) }}
{%- endmacro %}

{% macro get_delete_insert_merge_sql(target, source, unique_key, dest_columns) -%}
  {{ adapter_macro('get_delete_insert_merge_sql', target, source, unique_key, dest_columns) }}
{%- endmacro %}


{% macro common_get_merge_sql_v2(target, source, unique_key, dest_columns, predicates, non_update_columns, matched_predicates) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute="name") | join(', ') -%}
    {%- set on_clause = [] -%}
    {%- set when_matched_clause = [] -%}
    {%- set full_refresh_mode = (flags.FULL_REFRESH == True) -%}
    

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

    {%- if predicates %}
        {%- if full_refresh_mode %}
            {% do on_clause.append('FALSE') %}
        {% else %}
            {% for predicate in predicates %}
                {% do on_clause.append('DBT_INTERNAL_DEST.' + predicate) %}
            {% endfor %}
        {%- endif %}
    {%- endif %}
    on {{ on_clause | join(' and ') -}}

    {% if unique_key %}
    when matched 
        {%- if matched_predicates %}
            {%- for matched_predicate in matched_predicates %}
                {%- set matched_predicate_match -%}
                    DBT_INTERNAL_SOURCE.{{ matched_predicate }} >= DBT_INTERNAL_DEST.{{ matched_predicate }}
                {%- endset -%}
                {% do when_matched_clause.append(matched_predicate_match) %}
            {%- endfor %}
            and {{- ' ' + when_matched_clause | join(' and ') -}} 
        {% endif %}
    
    then update set
        {%if non_update_columns %}
            {% for column in dest_columns -%}
            
                {% if column.name.lower() not in non_update_columns -%}
                    {{ column.name }} = DBT_INTERNAL_SOURCE.{{ column.name }}
                    {%- if not loop.last %}, {%- endif %}
                {% endif %}
            
            {%- endfor %}
        
        {%else %}
            {% for column in dest_columns -%}                
                {{ column.name }} = DBT_INTERNAL_SOURCE.{{ column.name }}
                {%- if not loop.last %}, {%- endif %}            
            {%- endfor %}
        {% endif %}

    {% endif %}

    when not matched then insert
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv }})

{%- endmacro %}




{% macro common_get_delete_insert_merge_sql(target, source, unique_key, dest_columns) -%}
    {%- set dest_cols_csv = dest_columns | map(attribute="name") | join(', ') -%}

    {% if unique_key is not none %}
    delete from {{ target }}
    where ({{ unique_key }}) in (
        select ({{ unique_key }})
        from {{ source }}
    );
    {% endif %}

    insert into {{ target }} ({{ dest_cols_csv }})
    (
        select {{ dest_cols_csv }}
        from {{ source }}
    );

{%- endmacro %}


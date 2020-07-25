{% macro snowflake__get_merge_sql_for_dim(target, source_sql, unique_key, dest_columns, surrogate_key, check_except, predicates) -%}

    {#
       Workaround for Snowflake not being happy with a merge on a constant-false predicate.
       When no unique_key is provided, this macro will do a regular insert. If a unique_key
       is provided, then this macro will do a proper merge instead.
    #}

    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute='name')) -%}
    {%- set sql_header = config.get('sql_header', none) -%}

    {%- if unique_key is none -%}

        {{ sql_header if sql_header is not none }}

        insert into {{ target }} ({{ dest_cols_csv }})
        (
            select {{ dest_cols_csv }}
            from {{ source_sql }}
        );

    {%- else -%}

        {{ default__get_merge_sql_for_dim(target, source_sql, unique_key, dest_columns, surrogate_key, check_except, predicates) }}

    {%- endif -%}

{% endmacro %}


{% macro get_merge_sql_for_dim(target, source, unique_key, dest_columns, surrogate_key, check_except, predicates=none) -%}
  {{ adapter_macro('get_merge_sql_for_dim', target, source, unique_key, dest_columns, surrogate_key, check_except, predicates) }}
{%- endmacro %}




{% macro default__get_merge_sql_for_dim(target, source, unique_key, dest_columns, surrogate_key, check_except, predicates) -%}
    {%- set predicates = [] if predicates is none else [] + predicates -%}
    {%- set dest_cols_csv = get_quoted_csv(dest_columns | map(attribute="name")) -%}
    {%- set sql_header = config.get('sql_header', none) -%}
    {%- set surrogate_key = none if surrogate_key is none else surrogate_key.upper() -%}
    {%- set check_except_upper = [] -%}
    {%- if check_except -%}
        {%- for col in check_except -%}
            {%- do check_except_upper.append(col.upper()) -%}
        {%- endfor -%}
    {%- endif -%}
    {%- set max_id = 0 -%}
    {%- set dest_cols_csv_sk = none -%}
    {%- set unique_key_csv = none -%}
    
    {%- if surrogate_key -%}
        {%- set max_id = get_max_id(this, surrogate_key) -%}
        {%- set dest_cols_csv_sk = dest_cols_csv | replace('"'~surrogate_key~'"','row_number() over( order by '~unique_key | join(',')~') + '~max_id) -%}
      
    {%- endif -%}
    
    {% if unique_key %}
        {%- for key in unique_key -%}
            {% set unique_key_match %}
                DBT_INTERNAL_SOURCE.{{ key }} = DBT_INTERNAL_DEST.{{ key }}
            {% endset %}
        {% do predicates.append(unique_key_match) %}
        {%- endfor -%}
    {% else %}
        {% do predicates.append('FALSE') %}
    {% endif %}

    {{ sql_header if sql_header is not none }}

    merge into {{ target }} as DBT_INTERNAL_DEST
        using {{ source }} as DBT_INTERNAL_SOURCE
        on {{ predicates | join(' and ') }}

    {% if unique_key %}
    when matched then update set
    {% if surrogate_key and not check_except_upper -%}
        {% for column in dest_columns -%}
            {% if column.name != surrogate_key -%}
                {{ adapter.quote(column.name) }} = DBT_INTERNAL_SOURCE.{{ adapter.quote(column.name) }}
                {%- if not loop.last %}, {%- endif %}
            {%- endif -%}
        {%- endfor %}

    {% elif check_except_upper  and not surrogate_key -%}
        {% for column in dest_columns -%}
            {% if column.name not in check_except_upper -%}
                {{ adapter.quote(column.name) }} = DBT_INTERNAL_SOURCE.{{ adapter.quote(column.name) }}
                {%- if not loop.last %}, {%- endif %}
            {%- endif -%}
        {%- endfor %}
    {% elif check_except_upper and surrogate_key -%}
        {% for column in dest_columns -%}
            {% if column.name not in check_except_upper and column.name != surrogate_key -%}
                {{ adapter.quote(column.name) }} = DBT_INTERNAL_SOURCE.{{ adapter.quote(column.name) }}
                {%- if not loop.last %}, {%- endif %}
            {%- endif -%}            
        {%- endfor %}
    {% else -%}
        {% for column in dest_columns -%}                
            {{ column.name }} = DBT_INTERNAL_SOURCE.{{ column.name }}
            {%- if not loop.last %}, {%- endif %}            
        {%- endfor %}
    {%- endif %}
    
    {% endif %}

    when not matched then insert
    {%- if not surrogate_key -%}
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv }})
    {%- else -%}
        ({{ dest_cols_csv }})
    values
        ({{ dest_cols_csv_sk }})
    {%- endif -%}

{% endmacro %}

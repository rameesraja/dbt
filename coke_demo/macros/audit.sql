


{% macro get_audit_relation() %}

    {%- set audit_schema = target.schema~'_meta' -%}

    {%- set audit_table =
        api.Relation.create(
            database=target.database,
            schema=audit_schema,
            identifier='dbt_audit_log',
            type='table'
        ) -%}

    {{ return(audit_table) }}

{% endmacro %}

{% macro log_audit_event(event_name, schema, relation, user, target_name, is_full_refresh) %}

    merge into {{ get_audit_relation() }} as audit
    using ( select * from ( values (
        '{{ invocation_id }}',
        {% if schema != None %}'{{ schema }}'{% else %}null::varchar(512){% endif %},
        {% if relation != None %}'{{ relation }}'{% else %}null::varchar(512){% endif %},
        {{ dbt_utils.current_timestamp_in_utc() }},
        {% if user != None %}'{{ user }}'{% else %}null::varchar(512){% endif %},
        {% if target_name != None %}'{{ target_name }}'{% else %}null::varchar(512){% endif %},
        {% if is_full_refresh %}TRUE{% else %}FALSE{% endif %}
        
    )) as val(invocation_id,schema_name,model_name,event_timestamp,invoked_by,target_environemnt,is_full_refresh_flag)

    ) as log

    on audit.invocation_id = log.invocation_id

    when not matched then 
        insert (invocation_id,schema_name,model_name,execution_start_date,execution_status,invoked_by,target_environemnt,is_full_refresh_flag)
        values ( log.invocation_id,log.schema_name,log.model_name,log.event_timestamp,'Started',log.invoked_by,log.target_environemnt,log.is_full_refresh_flag ) 

    when matched then
        update set  execution_end_date = log.event_timestamp, execution_status='Completed';    

    commit;

{% endmacro %}


{% macro create_audit_schema() %}
    {%- set audit_schema = target.schema~'_meta' -%}
    create schema if not exists {{ audit_schema }}
{% endmacro %}


{% macro create_audit_log_table() -%}

    {% set required_columns = [
       ["invocation_id", "varchar(512)"],
       ["schema_name", "varchar(512)"],
       ["model_name", "varchar(512)"],
       ["execution_start_date", dbt_utils.type_timestamp()],
       ["execution_end_date", dbt_utils.type_timestamp()],
       ["execution_status", "varchar(512)"],
       ["invoked_by", "varchar(512)"],
       ["target_environemnt", "varchar(512)"],
       ["is_full_refresh_flag", "boolean"],
       
    ] -%}

    {% set audit_table = get_audit_relation() -%}

    {% set audit_table_exists = adapter.get_relation(audit_table.database, audit_table.schema, audit_table.name) -%}


    {% if audit_table_exists -%}

        {%- set columns_to_create = [] -%}

        {# map to lower to cater for snowflake returning column names as upper case #}
        {%- set existing_columns = adapter.get_columns_in_relation(audit_table)|map(attribute='column')|map('lower')|list -%}

        {%- for required_column in required_columns -%}
            {%- if required_column[0] not in existing_columns -%}
                {%- do columns_to_create.append(required_column) -%}

            {%- endif -%}
        {%- endfor -%}


        {%- for column in columns_to_create -%}
            alter table {{ audit_table }}
            add column {{ column[0] }} {{ column[1] }}
            default null;
        {% endfor -%}

        {%- if columns_to_create|length > 0 %}
            commit;
        {% endif -%}

    {%- else -%}
        create table if not exists {{ audit_table }}
        (
        {% for column in required_columns %}
            {{ column[0] }} {{ column[1] }}{% if not loop.last %},{% endif %}
        {% endfor %}
        )
    {%- endif -%}

{%- endmacro %}


{% macro log_run_start_event() %}
    {{ log_audit_event('run started', user=target.user, target_name=target.name, is_full_refresh=flags.FULL_REFRESH) }}
{% endmacro %}


{% macro log_run_end_event() %}
    {{ log_audit_event('run completed', user=target.user, target_name=target.name, is_full_refresh=flags.FULL_REFRESH) }}
{% endmacro %}


{% macro log_model_start_event() %}
    {{log_audit_event(
        'model deployment started', schema=this.schema, relation=this.name, user=target.user, target_name=target.name, is_full_refresh=flags.FULL_REFRESH
    ) }}
{% endmacro %}


{% macro log_model_end_event() %}
    {{ log_audit_event(
        'model deployment completed', schema=this.schema, relation=this.name, user=target.user, target_name=target.name, is_full_refresh=flags.FULL_REFRESH
    ) }}
{% endmacro %}

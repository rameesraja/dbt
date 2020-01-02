{% snapshot events_dt_snapshot %}

{{
    config(
        target_database='DBT_WORKSHOP_BATCH_1',
        target_schema='RAMEES',
        unique_key='issue_id',
        strategy ='timestamp',
        updated_at = 'udt'
    
    )
}}

select * from events_dt
{% endsnapshot %}
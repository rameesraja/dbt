select 
'{{ invocation_id }}' as UUID,  
'{{ run_started_at.strftime("%Y-%m-%d") }}' as date_day, 
'{{ this }}' as current_scope , 
'{{ target.database }}' as tgt_database,
'{{ target.role }}' as tgt_role

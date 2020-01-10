{{ config(materialized='view',transient = 'False'
 ,pre_hook = "INSERT INTO audit_table(event_name,event_timestamp,event_schema,event_model)
               VALUES('Process Started',current_timestamp :: Timestamp_NTZ(9),'{{this.schema}}','{{this.name}}')"
 ,post_hook = "INSERT INTO audit_table(event_name,event_timestamp,event_schema,event_model)
               VALUES('Process Completed',current_timestamp :: Timestamp_NTZ(9),'{{this.schema}}','{{this.name}}')"
 ,tags = "nightly")}} -- tags are used to make model how frequent to run

 select * from {{ ref('Country') }}
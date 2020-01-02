-- create table events( id int,issue_id int, status varchar(100))

-- select * from events

-- insert into events values(1,1,'Started');
-- insert into events values(2,2,'In progress');
-- insert into events values(3,3,'Completed');

-- truncate table events

-- insert into events values(4,1,'In progress');
-- insert into events values(5,2,'Completed');
-- select * from UsingIncremental

{{
    config(
        materialized='incremental'
        
    )
}}

select * from events
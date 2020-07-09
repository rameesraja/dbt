{{
    config(
        
        tags = ['sales']
    )
}}


select * from (
    values(1,'atco','Calgary',to_timestamp_ntz('2020-01-01 01:02:03'),to_timestamp_ntz('2020-01-01 01:02:03')),
          (2,'wood','New York',to_timestamp_ntz('2020-01-01 01:02:10'),to_timestamp_ntz('2020-01-01 01:02:10')),
          (3,'tim','New York',to_timestamp_ntz('2020-01-01 01:03:03'),to_timestamp_ntz('2020-07-09 01:03:03'))
) as v1(id,name,city,created_on,updated_on)
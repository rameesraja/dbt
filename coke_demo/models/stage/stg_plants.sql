{{
    config(
        
        tags = ['manu']
    )
}}



select * from (
    values(1,'Fedricks','Calgary',to_timestamp_ntz('2020-01-01 01:02:03'),to_timestamp_ntz('2020-01-01 01:02:03')),
          (2,'Nancy','New York',to_timestamp_ntz('2020-01-01 01:02:10'),to_timestamp_ntz('2020-01-01 01:02:10'))
) as v1(id,name,city,created_on,updated_on)
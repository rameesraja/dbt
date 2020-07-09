{{
    config(
        
        tags = ['sales','manu']
    )
}}



select * from (
    values(1,'Cream',10,to_timestamp_ntz('2020-01-01 01:02:03'),to_timestamp_ntz('2020-01-01 01:02:03')),
          (2,'Bread',5,to_timestamp_ntz('2020-01-01 01:02:10'),to_timestamp_ntz('2020-01-01 01:02:10')),
          (3,'Jam',10,to_timestamp_ntz('2020-01-01 01:03:03'),to_timestamp_ntz('2020-01-01 01:03:03')),
          (3,'bottle',20,to_timestamp_ntz('2020-01-01 01:03:03'),to_timestamp_ntz('2020-01-01 01:03:03'))
) as v1(id,name,price,created_on,updated_on)
{{
    config(
        
        tags = ['sales']
    )
}}




select * from (
    values(1,'jam','tim',to_timestamp_ntz('2020-07-07 01:02:03'),20),
          (1,'bread','tim',to_timestamp_ntz('2020-07-07 01:02:03'),20),
          (1,'Cream','tim',to_timestamp_ntz('2020-07-07 01:02:03'),10),
          (2,'jam','atco',to_timestamp_ntz('2020-07-08 01:02:03'),20),
          (3,'bottle','wood',to_timestamp_ntz('2020-07-07 01:02:03'),50)
) as v1(id,material,customer,sales_time,order_qty)
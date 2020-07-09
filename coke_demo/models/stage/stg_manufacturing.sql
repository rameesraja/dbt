{{
    config(
        
        tags = ['manu']
    )
}}



select * from (
    values(to_date('2020-06-30'),'jam','Nancy',100),
          (to_date('2020-06-30'),'cream','Nancy',50),
          (to_date('2020-06-30'),'bread','Nancy',50),
          (to_date('2020-07-01'),'bottle','Fedricks',50)
          
) as v1(date,material,plant,qty)
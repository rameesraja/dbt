CREATE or replace PROCEDURE fct_sales_orders_proc(is_delta string)
  RETURNS VARCHAR NOT NULL
  language javascript
  as     
      $$

   var result = ""
  
   if(IS_DELTA == 'yes'){
   
       try{
         var merge_command = `merge into ramees.fct_sales_orders as tgt 
         using 
         ( select 
              order_id,
              material_id,
              customer_id,
              sales_at,
              sales_order_quantity,
              sales_order_quantity * material_price as sales_price 
          from ramees.clean_sales_orders sales_order 
          join ramees.dim_materials as materials 
              on materials.material_name = sales_order.material_name 
          join ramees.dim_customers as customers 
              on customers.customer_name = sales_order.customer_name
         ) as src 
             on tgt.order_id=src.order_id and tgt.material_id=src.material_id 
         when not matched 
             then insert(order_id,material_id,customer_id,sales_at,sales_order_quantity,sales_price)
             values(src.order_id,src.material_id,src.customer_id,src.sales_at,src.sales_order_quantity,src.sales_price) 
         when matched then update set               
                 tgt.material_id=src.material_id,
                 tgt.customer_id=src.customer_id,
                 tgt.sales_at=src.sales_at,
                 tgt.sales_order_quantity=src.sales_order_quantity,
                 tgt.sales_price=src.sales_price`
      
                  
         var statement1 = snowflake.createStatement( {sqlText: merge_command} )
          statement1.execute()
          result = "Succeeded"
       
       }
       catch (err)  {
          result =  "Failed: Code: " + err.code + "\n  State: " + err.state
          result += "\n  Message: " + err.message
          result += "\nStack Trace:\n" + err.stackTraceTxt
          }
   }
   else {
      try {
          var my_sql_command = `create or replace table ramees.fct_sales_orders as 
              (
                  select 
                      order_id,
                      material_id,
                      customer_id,
                      sales_at,
                      sales_order_quantity,
                      sales_order_quantity * material_price as sales_price 
                  from ramees.clean_sales_orders sales_order 
                  join ramees.dim_materials as materials 
                      on materials.material_name = sales_order.material_name 
                  join ramees.dim_customers as customers 
                      on customers.customer_name = sales_order.customer_name
              )`
          var statement1 = snowflake.createStatement( {sqlText: my_sql_command} )
          statement1.execute()
          result = "Succeeded"
          }
      catch (err)  {
          result =  "Failed: Code: " + err.code + "\n  State: " + err.state
          result += "\n  Message: " + err.message
          result += "\nStack Trace:\n" + err.stackTraceTxt
          }
      }
      return result

$$


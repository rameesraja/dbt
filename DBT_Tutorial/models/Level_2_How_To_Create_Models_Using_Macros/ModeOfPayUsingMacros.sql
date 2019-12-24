{{config(materialized = 'view')}}

SELECT  C.First_Name,C.Last_Name,P.Payment_Method,R.Status,R.Order_Date
FROM    raw_customers C JOIN raw_orders R
        ON C.ID = R.User_ID
        JOIN raw_payments P ON R.id = P.Order_ID
{{OrdersBTWMonths('2019-01-01','2019-10-10')}}        
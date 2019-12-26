{%macro ConIntVar(column_name)%}
case when try_to_number({{column_name}}) IS NULL THEN  TO_VARCHAR({{column_name}}) ELSE concat('0000',{{column_name}}) END as Col
{%endmacro%}
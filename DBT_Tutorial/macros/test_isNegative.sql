{% macro test_isNegative(model, column_name) %}

with val as
(

    select {{ column_name }} as col1
    from {{ model }}
),

val_err as
(

    select * from val where col1 <= 0
)

select count(*) from val_err

{% endmacro %}
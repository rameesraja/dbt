{% set result = run_query('select distinct payment_method from raw_payments') %}
{% if execute %}
{% set payment_methods = result.columns[0].values() %}
{% endif %}

select order_id,
{% for payment_method in payment_methods %}
sum( case when payment_method='{{payment_method}}' then amount else 0 end) as {{payment_method}}_mode,
{% endfor %}
sum(amount) as total_amount
from raw_payments
group by 1
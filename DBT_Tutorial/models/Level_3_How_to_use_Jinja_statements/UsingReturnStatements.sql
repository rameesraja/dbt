{% set payment_methods= ["credit_card","coupon","bank_transfer","gift_card"] %}

select order_id,
{% for payment_method in returnExample() %}
sum( case when payment_method='{{payment_method}}' then amount else 0 end) as {{payment_method}}_mode,
{% endfor %}
sum(amount) as total_amount
from raw_payments
group by 1
{% set dt=modules.datetime.datetime.now() %}
{% set est_dt=modules.pytz.timezone('US/Eastern').localize(dt) %}

select '{{ dt }}' as time_now,
'{{ est_dt }}' as est_time_now
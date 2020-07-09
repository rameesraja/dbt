select * from (
    values(1,to_timestamp_ntz('2020-01-01 01:02:03'),'take-off'),
          (2,to_timestamp_ntz('2020-01-01 01:02:10'),'on-air'),
          (3,to_timestamp_ntz('2020-01-01 01:03:03'),'on-air')
) as v1(id,event_time,status)
#!/usr/bin/env python
import snowflake.connector
import json
 
# Sample JSON string

with open('C:/Users/VisualBI/Downloads/run_results.json') as f:
  data = json.load(f)
 
# Connect to your Snowflake account
ctx = snowflake.connector.connect(
    account='visualbi.east-us-2.azure',
    user='rameesr',
    password='Frozen123',
    database='CCBCC',
    schema='RAMEES',
    role='SYSADMIN'
    )
cs = ctx.cursor()
try:
   
    cs.execute("insert into dummy1 (select PARSE_JSON('%s'))" % json.dumps(data))
finally:
    cs.close()
ctx.close()
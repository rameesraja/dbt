import json 
import requests



url = "https://cloud.getdbt.com/api/v2/accounts/1800/runs/6284178/artifacts/run_results.json"
headers = { "Authorization" : "Bearer a0e0f8398658b04d359459a5366ee1424cc1ce3d", "Content-Type": "application/json" }
resp = requests.get(url,headers=headers)
if resp.status_code != 200:
    print('error: ' + str(resp.status_code))
else:
    print('Success')
#print(resp.content)

#a = resp.content


a = json.loads(resp.content)
a['jobID'] = 1

print(a)


# for record in a['results']:
#     print(record['skip'])

#print(a['results'][1]['skip'])
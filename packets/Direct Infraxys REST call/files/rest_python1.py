#!/usr/bin/env python3.7

import os, requests

json = {
	"environmentGuid": "guid-1007",
	"asynchronous": False,
	"actions": [
		{
			"containerGuid": "guid-2405",
			"instanceGuid": "guid-46462",
			"filename": "sleep.sh"
		},
		{
			"containerGuid": "guid-2405",
			"instanceGuid": "a13eabdd-f8da-4ebe-a54c-c9fdb55885eb",
			"filename": "sleep.sh"
		}
	]
}


headers = {'Content-Type': 'application/json'}
url = "{}/{}".format(os.environ['INFRAXYS_REST_ENDPOINT'], 'environments/execute')
# bearer = ''; # get from a Variable or from an external Vault, ... Not needed for Infraxys developer
# headers.update({'Authorization': 'Bearer {}'.format(bearer),
#                'Content-Type': 'application/json'
#                })

print("Using REST endpoint: {}".format(url))
response = requests.request("POST", url, headers=headers, verify=False, json=json)

print("Status code: {}".format(response.status_code))
print(response.content)

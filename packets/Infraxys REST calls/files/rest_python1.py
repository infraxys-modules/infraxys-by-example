#!/usr/bin/env python3.7

import json, os, requests

json_string = """$instance.getAttribute("JSON")"""
json_object = json.loads(json_string)
request_method = '$instance.getAttribute("request_method")'
request_path = '$instance.getAttribute("request_path")'

headers = {'Content-Type': 'application/json'}
url = "{}/{}".format(os.environ['INFRAXYS_REST_ENDPOINT'], request_path)
# bearer = ''; # get from a Variable or from an external Vault, ... Not needed for Infraxys developer
# headers.update({'Authorization': 'Bearer {}'.format(bearer),
#                'Content-Type': 'application/json'
#                })

print("Executing {} to REST endpoint: {}".format(request_method, url))

response = requests.request(request_method, url, headers=headers, verify=False, json=json_object)

print("Status code: {}".format(response.status_code))
print(response.content)

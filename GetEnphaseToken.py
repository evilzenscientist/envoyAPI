import json 
import requests
user = 'email@foo.com'
password = 'StrongPassword123!'
envoy_serial = 'numericvalue'
data = {'user[email]': user, 'user[password]': password}
response = requests.post('https://enlighten.enphaseenergy.com/login/login.json', data=data)
response_data = json.loads(response.text)
print(response_data)
data = {'session_id': response_data['session_id'], 'serial_num': envoy_serial, 'username': user}
print(data)
response = requests.post('https://entrez.enphaseenergy.com/tokens', json=data)
token_raw = response.text
print(token_raw)

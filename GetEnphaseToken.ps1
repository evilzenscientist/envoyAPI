# set some urls
$e_login_url = "https://enlighten.enphaseenergy.com/login/login.json"
$e_token_url = "https://entrez.enphaseenergy.com/tokens"
$e_local_envoy = "https://localip"


# set some secrets/creds
# usually we would read these out of the Key Vault
$e_username = "email@foo.com"
$e_password = "ComplexPassword123!"
$e_serNum = "numericsitecode"

# set up login and token POST body
$login_body = @{
        'user[email]'=$e_username
        'user[password]'=$e_password
        }

$loginstatus = Invoke-webrequest -Method POST -Uri $e_login_url -body $login_body -ContentType 'application/x-www-form-urlencoded'

$session_id=(convertfrom-json $loginstatus.content).session_id

$token_body = @{
    'session_id'=$session_id
    'serial_num'=$e_serNum
    'username'=$e_username
}
$j_token_body = convertto-json $token_body -depth 1

$token_response = Invoke-webrequest -Method POST -Uri $e_token_url -body $j_token_body -ContentType 'application/json'

$token = $token_response.content

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

$auth_token = $token_response.content
# set some urls
$e_login_url = "https://enlighten.enphaseenergy.com/login/login.json"
$e_token_url = "https://entrez.enphaseenergy.com/tokens"
$e_local_envoy = "https://10.x.x.x"

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

#get the JWT
$auth_token = $token_response.content
# create the secure string
$s_auth_token = convertto-securestring -string $auth_token -AsPlainText -force

# login to the Envoy
# locally issued certificate, so we need -SkipCertificateCheck
# using newer PowerShell so -Authentication Bearer with the -Token
# older PowerShell, you'll be building a header and passing it in
$le_login_status =  invoke-webrequest -Method Get  -uri $e_local_envoy/auth/check_jwt -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -sessionvariable lesession

# get some stuff
# there are some good blogs and github repos that talk about the various on-Envoy APIs
# this is getting home.json and inventory.json
# you can now maniupulate and post to a data store at will
$e_home = (invoke-webrequest -Method Get  -uri $e_local_envoy/home.json -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -websession $lesession).content
$e_inventory = (invoke-webrequest -Method Get  -uri $e_local_envoy/inventory.json -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -websession $lesession).content

# assuming we have a valid token, it's good for an hour

# login to the Envoy
# locally issued certificate, so we need -SkipCertificateCheck
# using newer PowerShell so -Authentication Bearer with the -Token
# older PowerShell, you'll be building a header and passing it in
$le_login_status =  invoke-webrequest -Method Get  -uri $e_local_envoy/auth/check_jwt -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -sessionvariable lesession

# get some stuff
# there are some good blogs and github repos that talk about the various on-Envoy APIs
# this is getting home.json and inventory.json
# you can now maniupulate and post to a data store at will
$e_home = (invoke-webrequest -Method Get  -uri $e_local_envoy/home.json -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -websession $lesession).content
$e_inventory = (invoke-webrequest -Method Get  -uri $e_local_envoy/inventory.json -SkipCertificateCheck -Authentication Bearer -Token $s_auth_token -websession $lesession).content

# sample PowerShell to get API data from local Enphase Envoy
# set some urls
$e_login_url = "https://entrez.enphaseenergy.com/login"
$e_token_url = "https://entrez.enphaseenergy.com/entrez_tokens"
$e_local_envoy = "https://localipaddress"

# set some secrets/creds
$e_username = "Enphase username/email address"
$e_password = "Strong password"

$e_site = "Site Name"
$e_serNum = "Envoy Serial Number"

# set up login POST body
$login_body = @{
        username=$e_username
        password=$e_password
        }

# set up token POST body
$token_body = @{
    Site=$e_site
    serialNum=$e_serNum
        }

$contentType = 'application/x-www-form-urlencoded' 
# login to Entrez token service
# posting login_body as a form
# create sessionvariable
$loginstatus = Invoke-webrequest -Method POST -Uri $e_login_url -body $login_body -ContentType $contentType -sessionvariable entrezsession
# reuse sessionvariable
# retrieve html page containing JWT access token
$authstatus = Invoke-webrequest -Method POST -Uri $e_token_url -body $token_body -ContentType $contentType -websession $entrezsession

# build a regex pattern for the token
# this is the risky area and may change in the future
# read the raw $authstatus if this starts failing
$tk_regex_pattern = '(?<=rows="10" \>).+?(?=\<)' 

# extract the JWT from html body
$auth_token = [regex]::Matches($authstatus.content, $tk_regex_pattern).value

# ideally you should be testing the token here
# a great function here that lets you do that https://www.michev.info/Blog/Post/2140/decode-jwt-access-and-id-tokens-via-powershell

$s_auth_token = convertto-securestring -string $auth_token -AsPlainText -force

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


# envoyAPI

Get data from local Enphase Envoy with use of Entrez JWT

# authentication flow

So the flow:

- login, using Enphase username/password, to the Enphase Entrez token service
  - https://entrez.enphaseenergy.com/login
- get a JWT access token
  - https://entrez.enphaseenergy.com/entrez_tokens
- post this JWT to the local envoy
  - https://localenvoy/auth/check_jwt
- get data
  - https://localenvoy/APIendpoint

# Original blog post

Referenced from here https://evilzenscientist.com/2022/05/access-to-the-local-enphase-envoy-api-through-code/


#!/bin/bash
# http://localhost:9999/#confirmation_token=5d293nF4bOOr5gFoXTWidg

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"type": "signup", "token": "5d293nF4bOOr5gFoXTWidg", "password":"abcdefgh"}' \
  http://localhost:9999/verify


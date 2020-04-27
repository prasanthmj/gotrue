#!/bin/bash

curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"email":"pmj2@user10.com","password":"abcdefgh"}' \
  http://localhost:9999/signup
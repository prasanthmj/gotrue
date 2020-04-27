
#!/bin/bash
# http://localhost:9999/#confirmation_token=5d293nF4bOOr5gFoXTWidg

curl --header "Content-Type: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJhcGkubmV0bGlmeS5jb20iLCJleHAiOjE1ODc3MzA5MTUsInN1YiI6IjkzZGU4Y2NhLTQzOTYtNGVjYi05MGQ5LTgxMWUyNWNkYzE1MiIsImVtYWlsIjoicG1qMkB1c2VyMTAuY29tIiwiYXBwX21ldGFkYXRhIjp7InByb3ZpZGVyIjoiZW1haWwifSwidXNlcl9tZXRhZGF0YSI6e319.63tbcVEIfERxcSYjZs_0_qI9RZ8XvHf9uasImYRrsi8" \
  http://localhost:9999/user


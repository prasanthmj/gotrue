
## Docker Run Postgres
docker run --name samplepg -e POSTGRES_PASSWORD=abcdefg -e POSTGRES_USER=svcuser -e POSTGRES_DB=appdb -d -p 5432:5432 postgres



## Mailer

docker run --name mailer -d -p 8025:8025 -p 1025:1025 mailhog/mailhog:v1.0.0
# Rack::PushNotification Example

## Instructions

To run the example application, ensure that you have Postgres running locally (see [Postgres.app](http://postgresapp.com) for an easy way to get set up on a Mac), and run the following commands:

```sh
$ cd example
$ psql -c "CREATE DATABASE rack_push_notification;"
$ echo "DATABASE_URL=postgres://localhost:5432/rack_push_notification" > .env
$ echo "APN_CERTIFICATE_PATH=./apn_certificate_production.pem" >> .env
$ bundle
$ foreman start
```

# Rack::PushNotification Example

## Requirements

- Postgres 9.1 or above running locally (see [Postgres.app](http://postgresapp.com) for an easy way to get set up on a Mac)
- [Heroku Toolbelt](https://toolbelt.heroku.com)

## Instructions

To run the example application, run the following commands:

```sh
$ cd example
$ psql -c "CREATE DATABASE rack_push_notification;"
$ echo "DATABASE_URL=postgres://localhost:5432/rack_push_notification" > .env
$ bundle
$ foreman start
```

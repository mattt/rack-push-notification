# Rack::PushNotification

**A Rack-mountable web service for managing push notifications**

> This project is no longer maintained.

`Rack::PushNotification` is Rack middleware that
generates API endpoints that can be consumed by iOS apps
to register and unregister for push notifications.

**Example Record**

| Field        | Value                                                                       |
| ------------ | --------------------------------------------------------------------------- |
| `token`      | `"ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969"` |
| `alias`      | `mattt@heroku.com`                                                          |
| `badge`      | `0`                                                                         |
| `locale`     | `en_US`                                                                     |
| `language`   | `en`                                                                        |
| `timezone`   | `America/Los_Angeles`                                                       |
| `ip_address` | `0.0.0.0`                                                                   |
| `lat`        | `37.7716`                                                                   |
| `lng`        | `-122.4137`                                                                 |
| `tags`       | `["iPhone OS 6.0", "v1.0", "iPhone"]`                                       |

- Each device has a `token`,
  which uniquely identifies the app installation on a particular device.
- This token can be associated with an `alias`,
  which can be a domain-specific piece of identifying information,
  such as a username or e-mail address.
- A running `badge` count keeps track of the badge count to show on the app icon.
- A device's `locale` & `language` can be used to
  localize outgoing communications to that particular user.
- Having `timezone` information gives you the ability to
  schedule messages for an exact time of day and to
  ensure maximum impact (and minimum annoyance).
- An `ip_address` --- along with `lat` and `lng` ---
  lets you to specifically target users according to their geographic location.

> **Important**
> Use `Rack::PushNotification` in conjunction with some kind of authentication,
> so that the administration endpoints aren't publicly accessible.

## Usage

Rack::PushNotification can be run as Rack middleware or as a single web application.
All that's required is a connection to a Postgres database.
Define this with the environment variable `DATABASE_URL`.

> For rails, use the
> [`rails-database-url`](https://github.com/glenngillen/rails-database-url) gem
> to define this from the `database.yml`.

An example application can be found in the `/example` directory of this repository.

### config.ru

```ruby
require 'bundler'
Bundler.require

run Rack::PushNotification
```

## Deployment

`Rack::PushNotification` can be deployed to Heroku with the following commands:

```
$ heroku create
$ git push heroku master
```

## Contact

[Mattt](https://twitter.com/mattt)

## License

Rack::PushNotification is available under the MIT license.
See the LICENSE file for more info.

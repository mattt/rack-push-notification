Rack::PushNotification
======================
**A Rack-mountable webservice for managing push notifications**

> This is still in early stages of development, so proceed with caution when using this in a production application. Any bug reports, feature requests, or general feedback at this point would be greatly appreciated.

`Rack::PushNotification` generates API endpoints that can be consumed by iOS apps to register and unregister for push notifications. Along with the registration API, `Rack::PushNotification` spawns an admin console that gives you a convenient interface to manage device tokens and compose targeted push notification messages.

## Example Record

<table>
  <tr><td><tt>token</tt></td><td>"ce8be627 2e43e855 16033e24 b4c28922 0eeda487 9c477160 b2545e95 b68b5969"</td></tr>
  <tr><td><tt>alias</tt></td><td>mattt@heroku.com</td></tr>
  <tr><td><tt>badge</tt></td><td>0</td></tr>
  <tr><td><tt>locale</tt></td><td>en_US</td></tr>
  <tr><td><tt>language</tt></td><td>en</td></tr>
  <tr><td><tt>timezone</tt></td><td>America/Los_Angeles</td></tr>
  <tr><td><tt>ip_address</tt></td><td>0.0.0.0</td></tr>
  <tr><td><tt>lat</tt></td><td>37.7716</td></tr>
  <tr><td><tt>lng</tt></td><td>-122.4137</td></tr>
  <tr><td><tt>tags</tt></td><td><tt>["iPhone OS 6.0", "v1.0", "iPhone"]</tt></td></tr>
</table>

Each device has a `token`, which uniquely identifies the app installation on a particular device. This token can be associated with an `alias`, which can be a domain-specific piece of identifying information, such as a username or e-mail address. A running `badge` count is used to keep track of the badge count to show on the app icon.

A device's `locale` & `language` can be used to localize outgoing communications to that particular user. Having `timezone` information gives you the ability to schedule messages for an exact time of day, to ensure maximum impact (and minimum annoyance). `ip_address` as well as `lat` and `lng` allows you to specifically target users according to their geographic location.

**It is strongly recommended that you use `Rack::PushNotification` in conjunction with some sort of Rack authentication middleware, so that the administration endpoints are not accessible without some form of credentials.**

## Example Usage

Rack::PushNotification can be run as Rack middleware or as a single web application. All that is required is a connection to a Postgres database.

### config.ru

```ruby
require 'bundler'
Bundler.require

run Rack::PushNotification
```

An example application can be found in the `/example` directory of this repository.

## iOS Client Library

To get the full benefit of `Rack::PushNotification`, use the [Orbiter](https://github.com/mattt/Orbiter) library to register for Push Notifications on iOS.

```objective-c
#import "Orbiter.h"

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSURL *serverURL = [NSURL URLWithString:@"http://raging-notification-3556.herokuapp.com/"]
    Orbiter *orbiter = [[Orbiter alloc] initWithBaseURL:serverURL credential:nil];
    [orbiter registerDeviceToken:deviceToken withAlias:nil success:^(id responseObject) {
        NSLog(@"Registration Success: %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"Registration Error: %@", error);
    }];
}
```

## Deployment

`Rack::PushNotification` can be deployed to Heroku with the following commands:

```
$ heroku create
$ git push heroku master
```

## Contact

Mattt Thompson

- http://github.com/mattt
- http://twitter.com/mattt
- m@mattt.me

## License

Rack::PushNotification is available under the MIT license. See the LICENSE file for more info.

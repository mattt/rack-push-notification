require 'bundler'
Bundler.require

Rack::PushNotification::Admin.use Rack::Auth::Basic do |username, password|
  [username, password] == ['admin', ENV['ADMIN_CONSOLE_PASSWORD'] || ""]
end

use Rack::PushNotification::Admin, certificate: "/path/to/apn_certificate.pem",
                                   environment: :production
run Rack::PushNotification

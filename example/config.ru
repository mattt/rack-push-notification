require 'bundler'
Bundler.require

Rack::PushNotification::Admin.use Rack::Auth::Basic do |username, password|
  [username, password] == ['admin', ENV['ADMIN_CONSOLE_PASSWORD'] || ""]
end

use Rack::PushNotification::Admin, certificate: ENV['APN_CERTIFICATE_PATH'],
                                   environment: :production
run Rack::PushNotification

require 'bundler'
Bundler.require

STDOUT.sync = true

DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost:5432/push_notification")

run Rack::PushNotification

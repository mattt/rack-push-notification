require 'rack'
require 'rack/contrib'

require 'sinatra/base'
require 'sinatra/param'

require 'sequel'

module Rack
  class PushNotification < Sinatra::Base
    use Rack::PostBodyContentTypeParser
    helpers Sinatra::Param

    disable :raise_errors, :show_exceptions

    autoload :Device, 'rack/push-notification/models/device'

    configure do
      if ENV['DATABASE_URL']
        Sequel.extension :pg_array, :migration

        DB = Sequel.connect(ENV['DATABASE_URL'])
        DB.extend Sequel::Postgres::PGArray::DatabaseMethods
        Sequel::Migrator.run(DB, ::File.join(::File.dirname(__FILE__), 'push-notification/migrations'), table: 'push_notification_schema_info')
      end
    end

    before do
      content_type :json
    end

    put '/devices/:token/?' do
      param :languages, Array
      param :tags, Array

      record = Device.find(token: params[:token]) || Device.new
      record.set(params)

      code = record.new? ? 201 : 200

      if record.save
        status code
        {device: record}.to_json
      else
        status 400
        {errors: record.errors}.to_json
      end
    end

    delete '/devices/:token/?' do
      record = Device.find(token: params[:token]) or halt 404

      if record.destroy
        status 200
      else
        status 400
        {errors: record.errors}.to_json
      end
    end
  end
end

require 'rack'
require 'rack/contrib'

require 'sinatra/base'
require 'sinatra/param'

require 'sequel'

require 'rack/push-notification/version'

Sequel.extension(:pg_array)

module Rack::PushNotification
end

module Rack
  def self.PushNotification(options = {})
    klass = Rack::PushNotification.const_set("Device", Class.new(Sequel::Model))
    klass.dataset = :devices

    klass.class_eval do
      self.strict_param_setting = false
      self.raise_on_save_failure = false

      plugin :json_serializer, naked: true, except: :id 
      plugin :validation_helpers
      plugin :timestamps, force: true
      plugin :schema

      set_schema do
        primary_key :id

        column :token,      :varchar,       null: false, unique: true
        column :alias,      :varchar 
        column :badge,      :int4,          null: false, default: 0
        column :locale,     :varchar
        column :language,   :varchar
        column :timezone,   :varchar,       null: false, default: 'UTC'
        column :ip_address, :inet
        column :lat,        :float8
        column :lng,        :float8
        column :tags,       :'text[]'

        index :token
        index :alias
        index [:lat, :lng]
      end

      create_table unless table_exists?

      def before_validation
        normalize_token!
      end

      private

      def normalize_token!
        self.token = self.token.strip.gsub(/[<\s>]/, '')
      end
    end

    app = Class.new(Sinatra::Base) do
      use Rack::PostBodyContentTypeParser
      helpers Sinatra::Param

      disable :raise_errors, :show_exceptions

      before do
        content_type :json
      end

      get '/devices/?' do
        param :languages, Array
        param :tags, Array

        @devices = klass.dataset
        [:alias, :badge, :locale, :languages, :timezone, :tags].each do |attribute|
          @devices = @devices.filter(attribute => params[attribute]) if params[attribute]
        end
        
        @devices.to_json
      end

      put '/devices/:token/?' do
        param :languages, Array
        param :tags, Array

        @record = klass.new(params)
        @record.tags = nil
        if @record.save
          status 201
          @record.to_json
        else
          status 406
          {errors: @record.errors}.to_json
        end
      end

      get '/devices/:token/?' do
        @record = klass.find(token: params[:token])
        if @record
          @record.to_json
        else
          status 404
        end
      end

      delete '/devices/:token/?' do
        @record = klass.find(token: params[:token]) or halt 404
        if @record.destroy
          status 200
        else
          status 406
          {errors: record.errors}.to_json
        end
      end
    end

    return app
  end

  module PushNotification
    class << self
      def new(options = {})
        @app ||= ::Rack::PushNotification()
      end

      def call(*args)
        @app ||= ::Rack::PushNotification()
        @app.call(*args)
      end
    end
  end
end

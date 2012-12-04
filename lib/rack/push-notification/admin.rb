require 'coffee-script'
require 'eco'
require 'sass'
require 'compass'
require 'bootstrap-sass'
require 'sprockets'
require 'sprockets-sass'
require 'houston'

module Rack
  class PushNotification::Admin < Sinatra::Base
    use Rack::Static, urls: ['/images'], root: ::File.join(root, "assets")
    use Rack::PostBodyContentTypeParser

    helpers Sinatra::Param

    set :root, ::File.dirname(__FILE__)
    set :views, Proc.new { ::File.join(root, "assets/views") }
    
    set :assets, Sprockets::Environment.new(::File.join(settings.root, "assets"))
    settings.assets.append_path "javascripts"
    settings.assets.append_path "stylesheets"

    def initialize(app = nil, options = {})
      super(app)

      self.class.set :apn_certificate, options.delete(:certificate)
      self.class.set :apn_environment, options.delete(:environment)
    end

    before do
      content_type :json
    end

    get '/devices/?' do
      param :q, String
      param :offset, Integer, default: 0
      param :limit, Integer, max: 100, min: 1, default: 25

      @devices = ::Rack::PushNotification::Device.dataset
      @devices = @devices.filter("tsv @@ to_tsquery('english', ?)", "#{params[:q]}:*") if params[:q] and not params[:q].empty?
      
      {
        devices: @devices.limit(params[:limit], params[:offset]),
        total: @devices.count
      }.to_json
    end

    get '/devices/:token/?' do
      @record = ::Rack::PushNotification::Device.find(token: params[:token])

      if @record
        @record.to_json
      else
        status 404
      end
    end

    head '/message' do
      status 503 and return unless client

      status 204
    end

    post '/message' do
      status 503 and return unless client

      param :payload, String, empty: false
      param :tokens, Array, empty: false

      tokens = params[:tokens] || ::Rack::PushNotification::Device.all.collect(&:token)

      options = JSON.parse(params[:payload])
      options[:alert] = options["aps"]["alert"]
      options[:badge] = options["aps"]["badge"]
      options[:sound] = options["aps"]["sound"]
      options.delete("aps")

      begin
        notifications = tokens.collect{|token| Houston::Notification.new(options.update({device: token}))}
        client.push(*notifications)

        status 204
      rescue => error
        status 500

        {error: error}.to_json
      end
    end

    get "/javascripts/:file.js" do
      content_type "application/javascript"

      settings.assets["#{params[:file]}.js"]
    end

    get "/stylesheets/:file.css" do
      content_type "text/css"

      settings.assets["#{params[:file]}.css"]
    end

    get '*' do
      content_type :html

      haml :index
    end

    private

    def client
      begin
        return nil unless settings.apn_certificate and ::File.exist?(settings.apn_certificate)
        
        client = case settings.apn_environment.to_sym
                  when :development 
                    Houston::Client.development
                  when :production
                    Houston::Client.production
                  end
        client.certificate = ::File.read(settings.apn_certificate)
        
        return client
      rescue
        return nil
      end
    end
  end
end

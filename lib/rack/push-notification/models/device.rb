module Rack
  class PushNotification::Device < Sequel::Model
    self.dataset = :devices

    self.strict_param_setting = false
    self.raise_on_save_failure = false

    plugin :json_serializer, naked: true
    plugin :validation_helpers
    plugin :timestamps, force: true
    plugin :schema

    def before_validation
      normalize_token!
    end

    def validate
      validates_presence :token
      validates_unique :token
      validates_format /[[:xdigit:]]{40}/, :token
    end

    private

    def normalize_token!
      self.token = self.token.strip.gsub(/[<\s>]/, '')
    end
  end
end

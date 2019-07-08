# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'rack/push-notification/version'

Gem::Specification.new do |s|
  s.name        = 'rack-push-notification'
  s.authors     = ['Mattt']
  s.email       = 'mattt@me.com'
  s.homepage    = 'https://mat.tt'
  s.version     = Rack::PushNotification::VERSION
  s.licenses    = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Rack::PushNotification'
  s.description = 'Generate a REST API for registering and querying push notification device tokens.'

  s.add_dependency 'rack', '~> 1.4'
  s.add_dependency 'rack-contrib', '~> 1.1'
  s.add_dependency 'sequel', '>= 3.0'
  s.add_dependency 'sinatra', '~> 1.3'
  s.add_dependency 'sinatra-param', '~> 0.1'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.files         = Dir['./**/*'].reject { |file| file =~ %r{\./(bin|example|log|pkg|script|spec|test|vendor)} }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end

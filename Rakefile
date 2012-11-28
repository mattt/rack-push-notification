require "bundler"
Bundler.setup

gemspec = eval(File.read("rack-push-notification.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rack-push-notification.gemspec"] do
  system "gem build rack-push-notification.gemspec"
end

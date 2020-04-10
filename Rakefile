# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'interactive-rake'
require 'app-manager'

AppManager.configure do |config|
  config.environment = ENV.fetch('PROJECT_ENV')
  config.config_path = ENV.fetch('PROJECT_CONFIG')
end

task :ssh do
  AppManager.ssh_handler.call
end

task :ssl_upload do
  AppManager.ssl_upload.call
end

task :ssl_deploy do
  AppManager.ssl_deploy.call
end


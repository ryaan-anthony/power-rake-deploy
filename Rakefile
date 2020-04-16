# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'interactive-rake'
require 'application'

Application.configure do |config|
  config.environment = ENV.fetch('PROJECT_ENV')
  config.config_path = ENV.fetch('PROJECT_CONFIG')
end

task :ssh do
  Application.ssh_handler
end

task :ssl_upload do
  Application.ssl_upload
end

task :ssl_deploy do
  Application.ssl_deploy
end


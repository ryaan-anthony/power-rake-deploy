# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'power-rake'
require 'config-reader'
require 'describe_instances'
require 'fetch_credentials'

current_env = ENV.fetch('RAKE_ENV')
current_config = ENV.fetch('RAKE_CONFIG')
config = ConfigReader.new(current_config, current_env).config
namespace = "#{config.project}-#{current_env}"

task :ssh do
  # Find matching instances
  query = "#{namespace}-*"
  results = DescribeInstances.new('Name', query).call
  abort "No results for Name=#{query}" if results.nil?

  # Fetch matching credentials
  secret_id = "#{namespace}-credentials"
  credentials = FetchCredentials.new(secret_id).call
  abort "No credentials for #{secret_id}" if credentials.nil?

  # Output table of instances
  headers = 'instance_id,state,public_ip_address,launch_time'
  formatted = results.map { |result| result.values.join(',') }
  try "echo '#{formatted.unshift(headers).join("\n")}' | column -s ',' -t"

  # Prompt user to select an instance
  message = "Instance ID (#{results.first[:instance_id]}): "
  instance_id = prompt(message) || results.first[:instance_id]
  selected = results.detect { |result| result[:instance_id] == instance_id }

  # Generate temp private key for ssh
  file = Tempfile.new
  file.write(credentials['private_key_pem'])
  file.close
  system "ssh -i #{file.path} #{credentials['user']}@#{selected[:public_ip_address]}"
  file.unlink
end

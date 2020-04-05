# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'power-rake'
require 'describe_instances'
require 'fetch_credentials'

NAMESPACE = "#{PowerRake.config.project}-#{PowerRake.current_env}"
task :ssh do
  # Find matching instances
  query = "#{NAMESPACE}-*"
  results = DescribeInstances.new('Name', query).call
  abort "No results for Name=#{query}" if results.nil?

  # Fetch matching credentials
  secret_id = "#{NAMESPACE}-credentials"
  credentials = FetchCredentials.new(secret_id).call
  abort "No credentials for #{secret_id}" if credentials.nil?

  # Output table of instances
  headers = 'instance_id,state,public_ip_address,launch_time'
  formatted = results.map { |result| result.values.join(',') }
  try "echo '#{formatted.unshift(headers).join("\n")}' | column -s ',' -t"

  # Prompt user to select an instance
  response = prompt("Instance ID (#{results.first[:instance_id]}): ")
  instance_id = response.empty? ? results.first[:instance_id] : response
  selected = results.detect { |result| result[:instance_id] == instance_id }

  # Generate temp private key for ssh
  file = Tempfile.new
  file.write(credentials['private_key_pem'])
  file.close
  system "ssh -i #{file.path} #{credentials['user']}@#{selected[:public_ip_address]}"
  file.unlink
end

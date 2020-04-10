# frozen_string_literal: true
require 'aws/describe_instances'
require 'aws/fetch_credentials'

class SshHandler
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call
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
    system "echo '#{formatted.unshift(headers).join("\n")}' | column -s ',' -t"

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

  private

  def namespace
    "#{app.config.project}-#{app.environment}"
  end
end

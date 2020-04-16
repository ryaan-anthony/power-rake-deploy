# frozen_string_literal: true
require 'aws/describe_instances'
require 'aws/fetch_credentials'
require 'net/scp'

class UploadToServer
  attr_reader :app

  def initialize(app)
    @app = app
  end


  def call(upload_list)
    hosts.each do |host|
      Net::SCP.start(host, username, keys: [], key_data: [private_key], keys_only: true) do |scp|
        upload_list.each { |local, remote| scp.upload! local, remote }
      end
    end
  end

  private

  def hosts
    instances.map { |instance| instance[:public_ip_address] }
  end

  def username
    credentials['user']
  end

  def private_key
    credentials['private_key_pem']
  end

  def instances
    @instances ||= DescribeInstances.new('Name', namespace).call || abort("No results for Name=#{namespace}")
  end

  def credentials
    @credentials ||= FetchCredentials.new("#{app.config.project}-#{app.environment}-credentials").call || abort("No credentials for #{namespace}")
  end

  def namespace
    "#{app.config.project}-#{app.environment}-*"
  end
end

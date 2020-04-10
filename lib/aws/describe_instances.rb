# frozen_string_literal: true
require 'aws-sdk-ec2'

class DescribeInstances
  attr_reader :key, :value

  def initialize(key, value)
    @key = key
    @value = Array(value)
  end

  def call
    describe_instances.reservations.each_with_object([]) do |reservation, memo|
      reservation.instances.each do |instance|
        memo << {
          instance_id: instance.instance_id,
          state: instance.state.name,
          public_ip_address: instance.public_ip_address,
          launch_time: instance.launch_time,
        }
      end
    end
  end

  private

  def describe_instances
    client.describe_instances(
      filters: [
        {
          name: "tag:#{key}",
          values: value
        }
      ]
    )
  end

  def client
    Aws::EC2::Client.new
  end
end
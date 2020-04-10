# frozen_string_literal: true
require 'aws-sdk-secretsmanager'

class FetchCredentials
  attr_reader :secret_id

  def initialize(secret_id)
    @secret_id = secret_id
  end

  def call
    response = client.get_secret_value(secret_id: secret_id)

    JSON.parse(
      response.secret_string ?
        response.secret_string :
        Base64.decode64(response.secret_binary)
    )
  end

  private

  def client
    Aws::SecretsManager::Client.new
  end
end
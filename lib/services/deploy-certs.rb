# frozen_string_literal: true
require 'vault'

class DeployCerts
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call
    certificate = ssl_data[:certificate]
    private_key = ssl_data[:private_key]
    cert_chain = ssl_data[:cert_chain]
    dh_params = ssl_data[:dh_params]
    # TODO export it
  end

  private

  def ssl_data
    @ssl_data ||= Vault.logical.read(vault_path).data[:data]
  end

  def vault_path
    app.config.ssl_out['vault_path']
  end
end

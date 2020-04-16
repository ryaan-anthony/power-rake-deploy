# frozen_string_literal: true
require 'vault'

class DeployCerts
  attr_reader :app

  # @params [Application] app
  def initialize(app)
    @app = app
  end

  def call
    certificate = file(ssl_data[:certificate])
    private_key = file(ssl_data[:private_key])
    cert_chain = file(ssl_data[:cert_chain])
    dh_params = file(ssl_data[:dh_params])

    app.upload_to_server(
      certificate.path => certificate_path,
      private_key.path => private_key_path,
      cert_chain.path => certificate_chain_path,
      dh_params.path => dh_params_path
    )

    certificate.unlink
    private_key.unlink
    cert_chain.unlink
    dh_params.unlink
  end

  private

  def certificate_path
    prompt("Path to certificate (#{app.config.ssl_out['cert_path']}):") || app.config.ssl_out['cert_path']
  end

  def private_key_path
    prompt("Path to private key (#{app.config.ssl_out['key_path']}):") || app.config.ssl_out['key_path']
  end

  def certificate_chain_path
    prompt("Path to certificate chain (#{app.config.ssl_out['cert_chain_path']}):") || app.config.ssl_out['cert_chain_path']
  end

  def dh_params_path
    prompt("Path to DH params (#{app.config.ssl_out['dh_params_path']}):") || app.config.ssl_out['dh_params_path']
  end

  def file(contents)
    file = Tempfile.new
    file.write(contents)
    file.close
    file
  end

  def ssl_data
    @ssl_data ||= Vault.logical.read(vault_path).data[:data]
  end

  def vault_path
    app.config.ssl_out['vault_path']
  end
end

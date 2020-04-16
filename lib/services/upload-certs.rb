# frozen_string_literal: true
require 'vault'

class UploadCerts
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call
    Vault.logical.write(
      app.config.ssl_out['vault_path'],
      data: app.fetch_local_certs
    )
  end
end

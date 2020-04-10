# frozen_string_literal: true

class FetchLocalCerts
  attr_reader :app

  def initialize(app)
    @app = app
  end

  def call
    {
      certificate: read_retry { certificate_path },
      private_key: read_retry { private_key_path },
      cert_chain: read_retry { certificate_chain_path },
      dh_params: read_retry { dh_params_path }
    }
  end

  private

  def read_retry(&block)
    loop do
      file_path = block.call
      next unless File.exists?(file_path)
      break IO.read(file_path)
    end
  end

  def certificate_path
    prompt("Path to certificate (#{app.config.ssl_in['cert_path']}):") || app.config.ssl_in['cert_path']
  end

  def private_key_path
    prompt("Path to private key (#{app.config.ssl_in['key_path']}):") || app.config.ssl_in['key_path']
  end

  def certificate_chain_path
    prompt("Path to certificate chain (#{app.config.ssl_in['cert_chain_path']}):") || app.config.ssl_in['cert_chain_path']
  end

  def dh_params_path
    prompt("Path to DH params (#{app.config.ssl_in['dh_params_path']}):") || app.config.ssl_in['dh_params_path']
  end
end

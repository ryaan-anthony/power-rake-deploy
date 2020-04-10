# frozen_string_literal: true
require 'config-reader'
require 'services/fetch-local-certs'
require 'services/ssh-handler'
require 'services/deploy-certs'
require 'services/upload-certs'

class AppManager
  class << self
    attr_accessor :config_path, :environment

    def configure
      yield(self)
    end

    def config
      @config ||= ConfigReader.new(config_path, environment).config
    end

    def ssh_handler
      SshHandler.new(self)
    end

    def ssl_upload
      UploadCerts.new(self)
    end

    def ssl_deploy
      DeployCerts.new(self)
    end

    def fetch_local_certs
      FetchLocalCerts.new(self)
    end
  end
end

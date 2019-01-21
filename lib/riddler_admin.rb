require "active_model_serializers"
require "acts_as_list"
require "bootstrap"
require "jquery-rails"
require "jquery-ui-rails"
require "ksuid"

require "riddler_admin/engine"
require "riddler_admin/configuration"
require "riddler"

module RiddlerAdmin
  def self.table_name_prefix
    "ra_"
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= ::RiddlerAdmin::Configuration.new
  end

  def self.encrypt plaintext, key:
    encoded_plaintext = Base64.strict_encode64 plaintext
    secret = Vault.logical.write "transit/encrypt/#{key}",
      plaintext: encoded_plaintext

    secret.data[:ciphertext]
  end

  def self.decrypt ciphertext, key:
    secret = Vault.logical.write "transit/decrypt/#{key}",
      ciphertext: ciphertext

    Base64.strict_decode64 secret.data[:plaintext]
  end
end

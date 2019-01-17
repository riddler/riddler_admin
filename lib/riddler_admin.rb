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
end

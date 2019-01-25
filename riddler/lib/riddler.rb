require "riddler/version"

require "liquid"
require "predicator"
require "ulid"

require "riddler/includeable"

require "riddler/drops/hash_drop"

require "riddler/configuration"

require "riddler/context_builder"
require "riddler/context_director"
require "riddler/context"

require "riddler/element"
require "riddler/elements/external_link"
require "riddler/elements/heading"
require "riddler/elements/image"
require "riddler/elements/text"
require "riddler/elements/variant"

require "riddler/step"
require "riddler/steps/content"
require "riddler/steps/variant"

require "riddler/use_cases/admin_preview_step"
require "riddler/use_cases/dismiss_interaction"
require "riddler/use_cases/preview_context"
require "riddler/use_cases/preview_step"
require "riddler/use_cases/show_definition"
require "riddler/use_cases/show_step"
require "riddler/use_cases/show_slug"

module Riddler
  class Error < StandardError; end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= ::Riddler::Configuration.new
  end
end

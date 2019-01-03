module Riddler

  class ContextBuilder
    attr_reader :context

    def initialize context
      @context = context
    end

    # Inspect context for identifiers or data.
    # Add any additional relevant information to the context
    def process
      # no-op
    end
  end

end

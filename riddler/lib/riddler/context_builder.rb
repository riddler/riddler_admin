module Riddler
  class ContextBuilder
    attr_reader :context

    def initialize context
      @context = context
    end

    # Does the current context have the data available for this builder
    # to function
    def data_available?
      true
    end

    # Extract IDs from the context (params, headers, JWTs, etc) and store
    # them in context.ids
    def extract_ids
      # no-op
    end

    # Inspect context for identifiers or data.
    # Add any additional relevant information to the context
    def process
      # no-op
    end

    private

    # Adds the ID to the context and defines a method for the ID
    def add_id name, value
      context.add_id name, value
      define_singleton_method(name) { value }
    end
  end
end

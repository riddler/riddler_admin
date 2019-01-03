module Riddler

  class ContextDirector
    attr_reader :params, :headers

    def initialize params: {}, headers: {}
      @params = params
      @headers = headers
    end

    # Create a new context and use registered builders to fill it in
    def context
      ctx = ::Riddler::Context.new params: params, headers: headers
      apply_builders ctx
      ctx
    end

    private

    def apply_builders ctx
      ::Riddler.configuration.context_builders.each do |builder_class|
        builder = builder_class.new ctx
        builder.process
      end
    end
  end

end

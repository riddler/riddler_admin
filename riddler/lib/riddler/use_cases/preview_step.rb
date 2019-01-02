module Riddler
  module UseCases

    class PreviewStep
      attr_reader :definition, :params, :headers, :step

      def initialize definition, params: {}, headers: {}
        @definition = definition
        @params = params
        @headers = headers
        @step = ::Riddler::Step.for definition, context
      end

      def context
        @context ||= begin
          builder = ::Riddler::ContextBuilder.new params: params,
            headers: headers
          builder.build
        end
      end

      def process
        step.to_hash
      end
    end

  end
end

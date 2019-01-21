module Riddler
  module UseCases
    class AdminPreviewStep
      attr_reader :definition, :preview_context_data, :context, :step

      def initialize definition, preview_context_data: {}
        @definition = definition
        @preview_context_data = preview_context_data
        @context = ::Riddler::Context.new preview_context_data
        @step = ::Riddler::Step.for definition, context
      end

      def process
        step.to_hash
      end
    end
  end
end

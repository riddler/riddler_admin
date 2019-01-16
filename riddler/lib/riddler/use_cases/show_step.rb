module Riddler
  module UseCases
    class ShowStep
      attr_reader :content_definition_repo,
        :step_id, :version, :params, :headers,
        :content_definition, :context, :step

      def initialize content_definition_repo:, step_id:, version:, params: {}, headers: {}
        @content_definition_repo = content_definition_repo
        @step_id = step_id
        @version = version
        @params = params
        @headers = headers

        @content_definition = lookup_definition
        @step = ::Riddler::Step.for content_definition.definition, context
      end

      def context
        @context ||= generate_context
      end

      def process
        step.to_hash
      end

      private

      def lookup_definition
        content_definition_repo.find_by content_type: "step",
          content_id: step_id,
          version: version
      end

      def generate_context
        director = ::Riddler::ContextDirector.new params: params,
          headers: headers
        director.context
      end
    end
  end
end

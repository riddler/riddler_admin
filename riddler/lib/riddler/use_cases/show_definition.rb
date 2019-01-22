module Riddler
  module UseCases
    class ShowDefinition
      attr_reader :definition_repo,
        :definition_id, :params, :headers,
        :definition, :context, :step

      def initialize definition_repo:, definition_id:, params: {}, headers: {}
        @definition_repo = definition_repo
        @definition_id = definition_id
        @params = params
        @headers = headers

        @definition = lookup_definition
        @step = ::Riddler::Step.for definition.definition, context
      end

      def context
        @context ||= generate_context
      end

      def process
        step.to_hash
      end

      private

      def lookup_definition
        definition_repo.find_by id: definition_id
      end

      def generate_context
        director = ::Riddler::ContextDirector.new params: params,
          headers: headers
        director.context
      end
    end
  end
end

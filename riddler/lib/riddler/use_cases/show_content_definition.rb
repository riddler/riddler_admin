module Riddler
  module UseCases
    class ShowContentDefinition
      attr_reader :content_definition_repo,
        :content_definition_id, :context_director,
        :content_definition, :context, :step

      def initialize content_definition_repo:, content_definition_id:, context_director:
        @content_definition_repo = content_definition_repo
        @content_definition_id = content_definition_id
        @context_director = context_director

        @content_definition = lookup_content_definition
        @step = ::Riddler::Step.for content_definition.definition, context
      end

      def context
        context_director.context
      end

      def process
        step.to_hash
      end

      def excluded?
        !step.include?
      end

      private

      def lookup_content_definition
        content_definition_repo.find_by id: content_definition_id
      end

      def generate_context
        director = ::Riddler::ContextDirector.new params: params,
          headers: headers
        director.context
      end
    end
  end
end

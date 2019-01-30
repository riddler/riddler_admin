module Riddler
  module UseCases
    class ShowSlug
      attr_reader :definition_repo, :slug_repo, :interaction_repo,
        :slug_name, :params, :headers,
        :slug, :interaction

      def initialize definition_repo:, slug_repo:, interaction_repo:,
        slug_name:, params: {}, headers: {}

        @definition_repo = definition_repo
        @slug_repo = slug_repo
        @interaction_repo = interaction_repo
        @slug_name = slug_name
        @params = params
        @headers = headers
        @slug = lookup_slug
      end

      def exists?
        !slug.nil?
      end

      def paused?
        return true if slug.nil?
        slug.status == "paused"
      end

      def dismissed?
        return false unless slug_defines_identity?
        find_interaction
        return false if @interaction.nil?
        @interaction.status == "dismissed"
      end

      def completed?
        return false unless slug_defines_identity?
        find_interaction
        return false if @interaction.nil?
        @interaction.status == "completed"
      end

      def excluded?
        definition_use_case.excluded?
      end

      def process
        find_interaction || create_interaction
        definition_use_case.process.merge interaction_id: interaction.id
      end

      private

      def find_interaction
        return nil unless request_is_unique?

        @interaction ||= interaction_repo.last_by slug: slug_name,
          identity: identity
      end

      def create_interaction
        @interaction = Entities::Interaction.new slug: slug_name,
          status: "active",
          definition_id: slug.definition_id,
          identifiers: context.ids

        @interaction.identity = identity if request_is_unique?

        interaction_repo.create interaction
      end

      def definition_use_case
        @definition_use_case ||= ShowDefinition.new \
          definition_repo: definition_repo,
          definition_id: slug.definition_id,
          params: params,
          headers: headers
      end

      def context
        definition_use_case.context
      end

      # Only has IDs extracted - context builders have not been processed
      def simple_context
        @simple_context = ::Riddler::ContextDirector.new(params: params, headers: headers).simple_context
      end

      def identity
        @identity ||= simple_context.render slug.interaction_identity
      end

      def blank_interaction_identity
        @blank_interaction_identity ||= ::Riddler::Context.new.render slug.interaction_identity
      end

      def request_is_unique?
        slug_defines_identity? && !interaction_identity_is_blank?
      end

      def interaction_identity_is_blank?
        identity == blank_interaction_identity
      end

      def slug_defines_identity?
        !(slug.interaction_identity.nil? || slug.interaction_identity == "")
      end

      def lookup_slug
        slug_repo.find_by name: slug_name
      end
    end
  end
end

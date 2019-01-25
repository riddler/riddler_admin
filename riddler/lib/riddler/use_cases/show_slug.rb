module Riddler
  module UseCases
    class ShowSlug
      attr_reader :definition_repo, :slug_repo, :interaction_repo,
        :slug_name, :params, :headers,
        :slug, :context, :interaction

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
        return false unless interaction_identity_present?
        find_interaction
        return false if @interaction.nil?
        @interaction.status == "dismissed"
      end

      def process
        find_interaction || create_interaction
        definition_use_case.process.merge interaction_id: interaction.id
      end

      def find_interaction
        return nil unless interaction_identity_present?

        @interaction ||= interaction_repo.last_by slug: slug_name,
          identity: identity
      end

      def create_interaction
        @interaction = Entities::Interaction.new slug: slug_name,
          status: "active",
          definition_id: slug.definition_id
        interaction.identity = identity if interaction_identity_present?

        interaction_repo.create interaction
      end

      def identity
        @identity ||= definition_use_case.context.render slug.interaction_identity
      end

      def definition_use_case
        @definition_use_case ||= ShowDefinition.new \
          definition_repo: definition_repo,
          definition_id: slug.definition_id,
          params: params,
          headers: headers
      end

      private

      def interaction_identity_present?
        !(slug.interaction_identity.nil? || slug.interaction_identity == "")
      end

      def lookup_slug
        slug_repo.find_by name: slug_name
      end
    end
  end
end

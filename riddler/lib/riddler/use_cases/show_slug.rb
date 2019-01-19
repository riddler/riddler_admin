module Riddler
  module UseCases
    class ShowSlug
      attr_reader :content_definition_repo, :slug_repo,
        :slug_name, :params, :headers,
        :slug, :context, :show_content_use_case

      def initialize content_definition_repo:, slug_repo:, slug_name:, params: {}, headers: {}
        @content_definition_repo = content_definition_repo
        @slug_repo = slug_repo
        @slug_name = slug_name
        @params = params
        @headers = headers

        @slug = lookup_slug
        @show_content_use_case = ShowContentDefinition.new \
          content_definition_repo: content_definition_repo,
          content_definition_id: slug.content_definition_id,
          params: params,
          headers: headers
      end

      def paused?
        slug.status == "paused"
      end

      def process
        show_content_use_case.process
      end

      private

      def lookup_slug
        slug_repo.find_by name: slug_name
      end
    end
  end
end

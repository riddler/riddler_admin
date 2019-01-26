module Riddler
  module UseCases
    class CompleteInteraction
      attr_reader :interaction_repo, :interaction_id

      def initialize interaction_repo:, interaction_id:
        @interaction_repo = interaction_repo
        @interaction_id = interaction_id
      end

      def process
        interaction = interaction_repo.find_by id: interaction_id
        return if interaction.nil?

        interaction.complete
        interaction_repo.update interaction
      end
    end
  end
end

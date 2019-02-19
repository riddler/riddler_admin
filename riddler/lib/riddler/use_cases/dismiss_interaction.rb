module Riddler
  module UseCases
    class DismissInteraction
      attr_reader :interaction_repo, :interaction_id, :interaction

      def initialize interaction_repo:, interaction_id:
        @interaction_repo = interaction_repo
        @interaction_id = interaction_id
      end

      def process
        @interaction = interaction_repo.find_by id: interaction_id
        return if interaction.nil?

        interaction.dismiss
        interaction_repo.update interaction
      end
    end
  end
end

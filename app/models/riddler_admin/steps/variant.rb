module RiddlerAdmin
  module Steps
    class Variant < Step
      has_many :steps, -> { order position: :asc },
        dependent: :destroy,
        as: :stepable

      def self.model_name
        Step.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["steps"] = steps.map { |s| s.definition_hash }
        hash
      end
    end
  end
end

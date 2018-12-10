module RiddlerAdmin
  module Steps
    class Content < Step
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      def self.model_name
        Step.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["elements"] = elements.map { |e| e.definition_hash }
        hash
      end
    end
  end
end

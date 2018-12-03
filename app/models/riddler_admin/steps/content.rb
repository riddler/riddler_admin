module RiddlerAdmin
  module Steps
    class Content < Step
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      def self.model_name
        Step.model_name
      end
    end
  end
end

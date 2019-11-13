module RiddlerAdmin
  module Toggles
    class Segment < Toggle
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      # validates :condition, parseable_predicate: true

      def self.model_name
        Toggle.model_name
      end

      def definition_hash options=nil
        hash = super
        opts = self.options || {}
        hash["condition"] = opts["condition"]
        hash["condition_instructions"] = ::Predicator.compile opts["condition"]
        hash
      end
    end
  end
end

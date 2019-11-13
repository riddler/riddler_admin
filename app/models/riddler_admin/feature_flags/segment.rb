module RiddlerAdmin
  module FeatureFlags
    class Segment < FeatureFlag
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      # validates :condition, parseable_predicate: true

      def self.model_name
        FeatureFlag.model_name
      end

      def definition_hash options=nil
        hash = super
        opts = self.options || {}
        if opts["condition"].present?
          hash["condition"] = opts["condition"]
          hash["condition_instructions"] = ::Predicator.compile opts["condition"]
        end
        hash
      end
    end
  end
end

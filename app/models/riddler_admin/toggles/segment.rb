module RiddlerAdmin
  module Toggles
    class Segment < Toggle
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      def self.model_name
        Toggle.model_name
      end

      def definition_hash options=nil
        hash = super
        hash
      end
    end
  end
end

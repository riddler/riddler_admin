module RiddlerAdmin
  module Elements
    class Variant < Element
      has_many :elements, -> { order position: :asc },
        dependent: :destroy,
        as: :container

      def self.model_name
        Element.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["elements"] = elements.map { |e| e.definition_hash }
        hash
      end
    end
  end
end

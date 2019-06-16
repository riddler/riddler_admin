module RiddlerAdmin
  module Elements
    class TextQuestion < Elements::Question
      validates_presence_of :text

      def self.model_name
        Element.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["text"] = text
        hash
      end
    end
  end
end

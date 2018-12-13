module RiddlerAdmin
  module Elements
    class Copy < Element
      validates_presence_of :text

      def self.model_name
        Element.model_name
      end
    end
  end
end

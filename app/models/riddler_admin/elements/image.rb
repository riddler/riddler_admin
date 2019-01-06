module RiddlerAdmin
  module Elements
    class Image < Element
      validates_presence_of :url

      def self.model_name
        Element.model_name
      end
    end
  end
end

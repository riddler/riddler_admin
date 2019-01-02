module RiddlerAdmin
  module Elements
    class Image < Element
      validates_presence_of :href

      def self.model_name
        Element.model_name
      end
    end
  end
end

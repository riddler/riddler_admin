module RiddlerAdmin
  module Elements
    class ExternalLink < Element
      validates_presence_of :url

      def self.model_name
        Element.model_name
      end
    end
  end
end

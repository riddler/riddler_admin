module RiddlerAdmin
  module Elements
    class ExternalLink < Element
      validates_presence_of :url

      def self.model_name
        Element.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["href"] = url
        hash["text"] = text
        hash
      end
    end
  end
end

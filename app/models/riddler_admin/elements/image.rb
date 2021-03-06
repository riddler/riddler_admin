module RiddlerAdmin
  module Elements
    class Image < Element
      validates_presence_of :url

      def self.model_name
        Element.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["src"] = url
        hash["alt"] = text
        hash
      end
    end
  end
end

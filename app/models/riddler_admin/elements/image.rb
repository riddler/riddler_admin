module RiddlerAdmin
  module Elements
    class Image < Element
      validates_presence_of :href

      def self.model_name
        Element.model_name
      end

      def definition_hash options=nil
        hash = super
        hash["href"] = href
        hash
      end
    end
  end
end

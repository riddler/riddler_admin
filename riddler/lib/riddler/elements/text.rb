module Riddler
  module Elements
    class Text < ::Riddler::Element
      def self.type
        "text"
      end

      def text
        context.render definition["text"]
      end

      def to_hash
        super.merge text: text
      end
    end
  end
end

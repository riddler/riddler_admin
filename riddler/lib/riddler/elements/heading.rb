module Riddler
  module Elements

    class Heading < ::Riddler::Element
      def self.type
        "heading"
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

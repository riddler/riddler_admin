module Riddler
  module Elements
    class Image < ::Riddler::Element
      def self.type
        "image"
      end

      def href
        context.render definition["href"]
      end

      def text
        context.render definition["text"]
      end

      def to_hash
        super.merge text: text, href: href
      end
    end
  end
end

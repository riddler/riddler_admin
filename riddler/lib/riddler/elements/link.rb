module Riddler
  module Elements
    class Link < ::Riddler::Element
      def self.type
        "link"
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

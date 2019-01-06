module Riddler
  module Elements
    class ExternalLink < ::Riddler::Element
      def self.type
        "external_link"
      end

      def href
        context.render definition["url"]
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

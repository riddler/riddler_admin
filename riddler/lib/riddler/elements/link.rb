module Riddler
  module Elements
    class Link < ::Riddler::Element
      def self.type
        "link"
      end

      def href
        @href ||= context.render definition["href"]
      end

      def link
        return href if context.variable(:interaction).nil?
        "/interactions/%s/redirect?element_id=%s&url=%s" % [
          context.interaction.id,
          definition["id"],
          href
        ]
      end

      def text
        context.render definition["text"]
      end

      def to_hash
        super.merge text: text, href: href, link: link
      end
    end
  end
end

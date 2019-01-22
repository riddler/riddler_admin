module Riddler
  module Elements
    class Image < ::Riddler::Element
      def self.type
        "image"
      end

      def src
        context.render definition["src"]
      end

      def alt
        context.render definition["alt"]
      end

      def to_hash
        super.merge alt: alt, src: src
      end
    end
  end
end

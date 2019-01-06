module Riddler
  module Elements
    class Image < ::Riddler::Element
      def self.type
        "image"
      end

      def src
        context.render definition["url"]
      end

      def text
        context.render definition["text"]
      end

      def to_hash
        super.merge text: text, src: src
      end
    end
  end
end

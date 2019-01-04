module Riddler
  module Elements
    class Varient < ::Riddler::Element
      def self.type
        "variant"
      end

      def to_hash
        included_element.to_hash
      end

      def included_element
        definition["elements"]
          .map do |hash|
            ::Riddler::Element.for hash, context
          end
          .detect(&:include?)
      end
    end
  end
end

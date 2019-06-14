module RiddlerAdmin
  class Visitor
    def accept node
      visit node
    end

    private

    DISPATCH_CACHE = Hash.new { |hash, (content_type, type)|
      hash[[content_type, type]] = :"visit_#{type.upcase}_#{content_type.upcase}"
    }

    def visit node
      send DISPATCH_CACHE[[node.content_type, node.type]], node
    end

  end
end

require_relative "visitors/each"
require_relative "visitors/dot"

module RiddlerAdmin
  module Visitors
    class Each < ::RiddlerAdmin::Visitor
      attr_reader :block

      def initialize block
        @block = block
      end

      private

      def visit node
        block.call node
        super
      end

      def terminal node
        node
      end

      def visit_steps node
        node.steps.each { |child| visit child }
      end

      alias :visit_CONTENT_STEP :terminal
      alias :visit_REDIRECT_STEP :terminal
      alias :visit_INPUT_STEP :terminal

      alias :visit_LINEARFLOW_STEP :visit_steps
      alias :visit_VARIANT_STEP :visit_steps
    end
  end
end

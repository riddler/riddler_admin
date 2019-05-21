module RiddlerAdmin
  module Visitors
    class Dot < ::RiddlerAdmin::Visitor
      class Graph
        INDENT_SIZE = 2

        attr_accessor :node, :nodes, :edges, :graphs

        def initialize node = nil
          @node = node
          @nodes = []
          @edges = []
          @graphs = []
        end

        def node_id
          @node.nil? ? "root" : @node.id
        end

        def node_name
          @node.nil? ? "root" : @node.name
        end

        def graph_type
          @node.nil? ? "digraph" : "subgraph"
        end

        def attributes_string
          attributes = ["node [shape=rectangle];", "edge [dir=none];"]
          attributes << 'size="8,5"' if @node.nil?
          attributes.join "\n"
        end

        def to_s level=0
          lines = []
          if @node.nil?
            lines << "#{indent level}#{graph_type} #{node_id} {"
            %W( rankdir=LR graph\ [compound=true] node\ [shape=rectangle] label="#{node_name}" ).each do |attr|
              lines << "#{indent level+1}#{attr}"
            end
          else
            lines << "#{indent level}#{graph_type} cluster_#{node_id} {"
            lines << %Q!#{indent level+1}label=""!
            lines << %Q!#{indent level+1}#{node_id} [label="#{node_name}" shape=plaintext]!
          end
          lines << "#{indent level+1}node [shape=rectangle];"
          nodes.each{ |node| lines << "#{indent level+1}#{node}" }
          edges.each{ |edge| lines << "#{indent level+1}#{edge}" }
          #graphs.each{ |graph| lines << "#{indent level+1}#{graph.to_s level+1}" }
          graphs.each{ |graph| lines << graph.to_s(level+1) }

          lines << "#{indent level}}"

          lines.join "\n"
        end

        private

        def indent level
          " " * level * INDENT_SIZE
        end
      end

      attr_reader :nodes, :edges

      def initialize
        @root = Graph.new
      end

      def current_graph
        @current_graph ||= @root
      end

      def accept node
        super
        binding.pry
        @root.to_s
      end

      private

      def terminal node
        current_graph.nodes << "#{node.id} [label=\"#{node.name}\"];"
      end

      def visit_steps node
        parent_graph = current_graph
        subgraph = Graph.new node
        parent_graph.graphs << subgraph
        @current_graph = subgraph
        #@subgraphs << "#{node.id} [label=\"#{node.name}\"];"
        node.steps.each do |child|
          #current_graph.edges << "#{node.id} -> #{child.id};"
          visit child
          yield child if block_given?
        end
        @current_graph = parent_graph
      end

      def visit_LINEARFLOW_STEP node
        previous_step = nil
        visit_steps node do |step|
          current_graph.edges << "#{previous_step.id} -> #{step.id}" unless previous_step.nil?
          previous_step = step
        end
      end

      def visit_VARIANT_STEP node
        previous_step = nil
        visit_steps node
      end

      alias :visit_CONTENT_STEP :terminal
      alias :visit_REDIRECT_STEP :terminal
      alias :visit_INPUT_STEP :terminal

      #alias :visit_LINEARFLOW_STEP :visit_steps
      #alias :visit_VARIANT_STEP :visit_steps





      #def visit_steps node
      #  p [:steps, node]
      #  node.steps.each do |child|
      #    @edges << "#{node.id} -> #{child.id};"
      #  end
      #  super
      #end

      ##def visit_VARIANT_STEP node
      ##  @nodes << "#{node.id} [label=\"VARIANT: #{node.name}\"];"
      ##  super
      ##end

      #def terminal node
      #  p [:terminal, node]
      #  @nodes << "#{node.id} [label=\"#{node.name}\"];"
      #end
    end
  end
end

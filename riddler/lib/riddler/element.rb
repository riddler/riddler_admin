module Riddler
  class Element
    attr_reader :definition, :context

    def self.for definition, context
      # This should be "type" not "object"
      element_type = definition["object"]

      # Maybe this should be a registry
      klazz = subclasses.detect { |klass| klass.type == element_type }

      klazz.new definition, context
    end

    def include?
      predicate = definition["include_predicate"]
      Predicator.evaluate(predicate, context.variables["params"])
    end

    def initialize definition, context
      @definition = definition
      @context = context
    end

    def to_hash
      {
        type: self.class.type,
        id: definition["id"],
        name: definition["name"]
      }
    end
  end
end

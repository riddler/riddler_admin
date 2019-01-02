module Riddler

  class Step
    attr_reader :definition, :context

    def self.for definition, context
      # This should be "type" not "object"
      step_type = definition["object"]

      # Maybe this should be a registry
      klass = subclasses.detect { |klass| klass.type == step_type }

      klass.new definition, context
    end

    def initialize definition, context
      @definition = definition
      @context = context
    end

    #def id
    #  definition["id"]
    #end

    #def type
    #  self.class.type
    #end

    def to_hash
      {
        type: self.class.type,
        id: definition["id"]
      }
    end
  end

end

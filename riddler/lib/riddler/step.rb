module Riddler
  class Step
    include ::Riddler::Includeable

    attr_reader :definition, :context, :preview_enabled

    def self.subclasses
      @@subclasses ||= []
    end

    def self.inherited subclass
      self.subclasses << subclass
    end

    def self.for definition, context
      step_type = definition["type"]

      klass = subclasses.detect { |k| k.type == step_type }

      klass.new definition, context
    end

    def initialize definition, context
      @definition = definition
      @context = context
    end

    def to_hash
      {
        type: self.class.type,
        id: definition["id"]
      }
    end
  end
end

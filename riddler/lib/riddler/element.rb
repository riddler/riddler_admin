module Riddler
  class Element
    include ::Riddler::Includeable

    attr_reader :definition, :context

    def self.subclasses
      @@subclasses ||= []
    end

    def self.inherited subclass
      self.subclasses << subclass
    end

    def self.for definition, context
      element_type = definition["type"]

      # Maybe this should be a registry
      klass = subclasses.detect { |k| k.type == element_type }

      klass.new definition, context
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

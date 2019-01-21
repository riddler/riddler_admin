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
      # This should be "type" not "object"
      element_type = definition["object"]

      # Maybe this should be a registry
      klazz = subclasses.detect { |klass| klass.type == element_type }

      klazz.new definition, context
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

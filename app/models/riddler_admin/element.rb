module RiddlerAdmin
  class Element < ApplicationRecord
    MODEL_KEY = "el".freeze
    ID_LENGTH = 6 # 56_800_235_584 per second

    belongs_to :container, polymorphic: true, validate: true

    acts_as_list scope: [:container_type, :container_id]

    validates_presence_of :name

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates_format_of :name, with: /\A[a-z][a-zA-Z0-9_]*\z/, message: "of Element ID cannot start with a capital letter or a number."

    def self.available_classes
      [
        Elements::ExternalLink,
        Elements::Heading,
        Elements::Image,
        Elements::Text,
        Elements::Variant
      ]
    end

    def self.default_class
      Elements::Text
    end

    def self.short_name
      name.demodulize
    end

    def self.to_partial_path
      "#{name.underscore}/class"
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
    end

    def short_name
      self.class.short_name
    end

    # Used in serialization
    def object
      type.demodulize.underscore
    end

    def definition_hash options=nil
      options ||= {}
      serializable_hash options.merge(serializable_hash_options)
    end

    def serializable_hash_options
      {
        methods: :object,
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :container_type, :container_id, :position]
    end

    def step
      if container.kind_of?(::RiddlerAdmin::Step)
        container
      else
        container.step
      end
    end
  end
end

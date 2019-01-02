module RiddlerAdmin
  class Element < ApplicationRecord
    MODEL_KEY = "el".freeze
    ID_LENGTH = 6 # 56_800_235_584 per second

    belongs_to :container, polymorphic: true, validate: true

    acts_as_list scope: [:container_type, :container_id]

    def self.available_classes
      [
        Elements::Heading,
        Elements::Text,
        Elements::Link
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
      [:created_at, :updated_at, :container_type, :container_id, :position, :name]
    end
  end
end

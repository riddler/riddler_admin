module RiddlerAdmin
  class Element < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "el".freeze
    ID_LENGTH = 6 # 56_800_235_584 per second

    after_initialize :set_defaults

    belongs_to :container, polymorphic: true, validate: true

    acts_as_list scope: [:container_type, :container_id]

    validates_presence_of :name

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates_format_of :name, with: /\A[a-z][a-zA-Z0-9_]*\z/, message: "cannot start with a capital letter or a number."
    validates_uniqueness_of :name, scope: [:container_type, :container_id], unless: :is_variant?

    validates :include_predicate, parseable_predicate: true

    def self.available_classes
      [
        Elements::Heading,
        Elements::Image,
        Elements::Link,
        Elements::Text,
        Elements::Variant,

        Elements::Button,
        Elements::TextQuestion
      ]
    end

    def self.default_class
      Elements::Text
    end

    def self.short_name
      name.demodulize
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
    end

    def short_name
      self.class.short_name
    end

    # Used in serialization
    def object
      type.demodulize
    end

    def content_type
      "Element"
    end

    def content_id
      id
    end

    def definition_hash options=nil
      options ||= {}
      hash = serializable_hash options.merge(serializable_hash_options)
      hash["type"] = object
      if hash["include_predicate"].blank?
        hash.delete "include_predicate"
      else
        hash["include_predicate_instructions"] = ::Predicator.compile hash["include_predicate"]
      end
      hash
    end

    def serializable_hash_options
      {
        methods: [:content_type],
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :container_type, :container_id, :position, :url, :text]
    end

    def step
      if container.kind_of? ::RiddlerAdmin::Step
        container
      else
        container.step
      end
    end

    private

    def is_variant?
      container.kind_of? ::RiddlerAdmin::Elements::Variant
    end

    def set_defaults
      self.name = short_name.underscore if name.blank?
    end
  end
end

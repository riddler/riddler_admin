module RiddlerAdmin
  class Step < ApplicationRecord
    MODEL_KEY = "st".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    validates_presence_of :title

    validates_presence_of :name

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates_format_of :name, with: /\A[a-z][a-zA-Z0-9_]*\z/,
      message: "must be a valid variable name (no spaces, start with character)"

    has_many :publish_requests,
      dependent: :nullify,
      as: :content

    has_many :content_definitions,
      dependent: :nullify,
      as: :content

    before_validation :set_defaults

    def self.default_class
      Steps::Content
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
    end

    # Used in serialization
    def object
      type.demodulize.underscore
    end

    def content_type
      "step"
    end

    def content_id
      id
    end

    def published?
      content_definitions.any?
    end

    def definition_hash options=nil
      options ||= {}
      serializable_hash options.merge(serializable_hash_options)
    end

    def serializable_hash_options
      {
        methods: [:object, :content_type, :content_id],
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :title, :preview_enabled]
    end

    private

    def set_defaults
      return if name.present?
      self.name = self.title.parameterize.underscore
    end
  end
end

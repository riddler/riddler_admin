module RiddlerAdmin
  class Step < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "st".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    belongs_to :stepable, polymorphic: true, optional: true
    acts_as_list scope: [:stepable_type, :stepable_id]

    validates_presence_of :title

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates :name, presence: true,
      format: {
        with: /\A[a-z][a-zA-Z0-9_]*\z/,
        message: "must be a valid variable name (no spaces, start with character)"
      }

    validates :include_predicate, parseable_predicate: true

    has_many :publish_requests,
      dependent: :nullify,
      as: :content

    has_many :content_definitions,
      dependent: :nullify,
      as: :content

    before_validation :set_defaults

    def self.available_classes
      [
        Steps::Content,
        Steps::Variant
      ]
    end

    def self.default_class
      Steps::Content
    end

    def self.short_name
      name.demodulize
    end

    def short_name
      self.class.short_name
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
      [:created_at, :updated_at, :title, :preview_enabled, :stepable_type, :stepable_id, :position]
    end

    private

    def set_defaults
      return if name.present?
      self.name = self.title.parameterize.underscore
    end
  end
end

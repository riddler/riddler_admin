module RiddlerAdmin
  class Email < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "em".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    belongs_to :emailable, polymorphic: true, optional: true
    acts_as_list scope: [:emailable_type, :emailable_id]

    validates_presence_of :title

    validates :name, presence: true, uniqueness: true,
      format: {
        with: /\A[a-z][a-zA-Z0-9_]*\z/,
        message: "must be a valid variable name (no spaces, start with character)"
      }

    has_many :elements, -> { order position: :asc },
      dependent: :destroy,
      as: :container

    has_many :publish_requests,
      dependent: :nullify,
      as: :content

    has_many :content_definitions,
      dependent: :nullify,
      as: :content

    before_validation :set_defaults

    def self.available_classes
      [
        Emails::Basic,
        Emails::Variant
      ]
    end

    def self.default_class
      Emails::Basic
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
      "email"
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
      hash.delete "include_predicate" if hash["include_predicate"].blank?
      hash
    end

    def serializable_hash_options
      {
        methods: [:content_type],
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :title, :preview_enabled, :emailable_type, :emailable_id,
       :position, :subject, :body, :css]
    end

    private

    def set_defaults
      return if name.present?
      self.name = self.title.parameterize.underscore
    end
  end
end

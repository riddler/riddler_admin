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

    has_many :enter_actions,
      -> { where("transition_type = ?", "enter").order(position: :asc) },
      class_name: "::RiddlerAdmin::Action",
      dependent: :destroy,
      as: :actionable

    has_many :exit_actions,
      -> { where("transition_type = ?", "exit").order(position: :asc) },
      class_name: "::RiddlerAdmin::Action",
      dependent: :destroy,
      as: :actionable

    has_many :publish_requests,
      dependent: :nullify,
      as: :content

    has_many :content_versions,
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
      type.demodulize
    end

    def content_type
      "Step"
    end

    def content_id
      id
    end

    def published?
      content_versions.any?
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
      if enter_actions.any?
        hash["enter_actions"] = enter_actions.map{ |a| a.definition_hash }
      end
      if exit_actions.any?
        hash["exit_actions"] = exit_actions.map{ |a| a.definition_hash }
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

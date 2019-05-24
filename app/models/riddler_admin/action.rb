module RiddlerAdmin
  class Action < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "act".freeze
    ID_LENGTH = 6

    belongs_to :actionable, polymorphic: true, validate: true

    acts_as_list scope: [:actionable_type, :actionable_id, :transition_type]

    validates :transition_type, presence: true, inclusion: { in: %w[ enter exit ] }

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates :name, presence: true,
      format: {
        with: /\A[a-z][a-zA-Z0-9_]*\z/,
        message: "must be a valid variable name (no spaces, start with character)"
      }

    validates_uniqueness_of :name, scope: [:actionable_type, :actionable_id]

    validates :include_predicate, parseable_predicate: true

    before_validation :set_defaults

    def self.available_classes
      [
        Actions::HTTPRequest
      ]
    end

    def self.default_class
      Actions::HTTPRequest
    end

    def self.short_name
      name.demodulize
    end

    def short_name
      self.class.short_name
    end

    def object
      type.demodulize
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
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
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :actionable_type, :actionable_id, :position, :transition_type]
    end

    private

    def set_defaults
      self.name = short_name.underscore if name.blank?
    end
  end
end

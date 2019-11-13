module RiddlerAdmin
  class Toggle < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "tog".freeze
    CARDINALITY = :small

    validates_presence_of :title

    # Alphanumeric and underscore only - no whitespace.
    # We might consider doing lowercase only for snake casing.
    validates :name, presence: true,
      format: {
        with: /\A[a-z][a-zA-Z0-9_]*\z/,
        message: "must be a valid variable name (no spaces, start with character)"
      }

    validates :include_condition, parseable_predicate: true

    before_validation :set_defaults

    def self.available_classes
      [
        Toggles::Segment
      ]
    end

    def self.default_class
      Toggles::Segment
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

    def definition_hash options=nil
      options ||= {}
      hash = serializable_hash options.merge(serializable_hash_options)
      hash["type"] = object
      if hash["include_condition"].blank?
        hash.delete "include_condition"
      else
        hash["include_condition_instructions"] = ::Predicator.compile hash["include_condition"]
      end
      hash
    end

    def serializable_hash_options
      {
        #methods: [:content_type],
        except: excluded_attrs
      }
    end

    def excluded_attrs
      [:created_at, :updated_at, :title]
    end

    private

    def set_defaults
      return if name.present?
      self.name = self.title.parameterize.underscore
    end
  end
end

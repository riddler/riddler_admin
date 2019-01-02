module RiddlerAdmin
  class Step < ApplicationRecord
    MODEL_KEY = "st".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    validates_presence_of :name

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
      [:created_at, :updated_at, :name]
    end
  end
end

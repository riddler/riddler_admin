module RiddlerAdmin
  class Element < ApplicationRecord
    MODEL_KEY = "el".freeze
    ID_LENGTH = 6 # 56_800_235_584 per second

    belongs_to :container, polymorphic: true, validate: true

    acts_as_list scope: [:container_type, :container_id]

    def self.available_classes
      [ Elements::Copy ]
    end

    def self.short_name
      name.demodulize
    end

    def self.to_partial_path
      "#{name.underscore}/class"
      #"riddler_admin/elements/#{short_name.underscore}/class"
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
      #"riddler_admin/elements/#{self.class.short_name.underscore}"
    end

    def short_name
      self.class.short_name
    end

    def self.default_class
      Elements::Copy
    end
  end
end

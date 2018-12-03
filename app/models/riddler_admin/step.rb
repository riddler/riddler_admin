module RiddlerAdmin
  class Step < ApplicationRecord
    MODEL_KEY = "st".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    def self.default_class
      Steps::Content
    end

    def to_partial_path detail=nil
      [self.class.name.underscore, detail].compact.join "/"
    end
  end
end

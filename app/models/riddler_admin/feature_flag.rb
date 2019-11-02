module RiddlerAdmin
  class FeatureFlag < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "ff".freeze
    ID_LENGTH = 5 # 916_132_832 per second
  end
end

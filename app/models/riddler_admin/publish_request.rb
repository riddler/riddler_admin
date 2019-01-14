module RiddlerAdmin
  class PublishRequest < ApplicationRecord
    MODEL_KEY = "pr".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    belongs_to :content, polymorphic: true

    validates :title, presence: true
    validates :content_definition, presence: true

    def approve approved_at = Time.now
      update_attributes approved_at: approved_at,
        status: "approved"
    end

    def approved?
      status == "approved"
    end

    def publish published_at = Time.now
      update_attributes published_at: published_at,
        status: "published"
    end

    def published?
      status == "published"
    end
  end
end

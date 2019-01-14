module RiddlerAdmin
  class PublishRequest < ApplicationRecord
    MODEL_KEY = "pr".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    # The Step or Element being published
    belongs_to :content, polymorphic: true

    # The Definition created as a result of this request
    has_one :content_definition

    validates :title, presence: true

    after_initialize :set_defaults

    def approve approved_at = Time.now
      update_attributes approved_at: approved_at,
        status: "approved"
    end

    def approved?
      approved_at.present?
    end

    def publish published_at = Time.now
      create_content_definition! content: content

      update_attributes published_at: published_at,
        status: "published"
    end

    def published?
      published_at.present?
    end

    private

    def set_defaults
      return if title.present? || content.blank?

      if content.published?
        self.title = "Update #{content.title}"
      else
        self.title = "Create #{content.title}"
      end
    end
  end
end

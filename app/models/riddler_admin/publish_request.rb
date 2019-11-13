module RiddlerAdmin
  class PublishRequest < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "pr".freeze
    CARDINALITY = :small

    # The Step or Element being published
    belongs_to :content, polymorphic: true

    # The ContentVersion created as a result of this request
    has_one :content_version

    validates :title, presence: true

    after_initialize :set_defaults

    scope :unapproved, -> { where "approved_at is null" }

    def approve riddler_user = nil, approved_at = Time.now.utc
      attrs = {status: "approved", approved_at: approved_at}
      if riddler_user.present?
        attrs[:approved_by_name] = ::RiddlerAdmin.config.user_name_block.call riddler_user
        attrs[:approved_by_id] = riddler_user.public_send ::RiddlerAdmin.config.user_id_method
      end

      update_attributes attrs
    end

    def approved?
      approved_at.present?
    end

    def publish published_at = Time.now.utc
      raise "ERROR: Attempt to publish an unapproved version" unless approved?
      create_content_version! content: content
      content_version.publish_to_remote

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

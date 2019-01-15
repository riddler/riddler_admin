require "riddler/content_management_services_pb"

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
      publish_to_remote

      update_attributes published_at: published_at,
        status: "published"
    end

    def published?
      published_at.present?
    end

    private

    def publish_to_remote
      content_management_stub.create_content_definition content_definition.grpc_request
    end

    def content_management_stub
      @content_management_stub ||= ::Riddler::ContentManagement::Stub.new \
        ::RiddlerAdmin.configuration.riddler_grpc_address,
        :this_channel_is_insecure
    end

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

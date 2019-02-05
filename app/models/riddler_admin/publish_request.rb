require "riddler/protobuf/content_management_services_pb"

module RiddlerAdmin
  class PublishRequest < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "pr".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    # The Step or Element being published
    belongs_to :content, polymorphic: true

    # The ContentDefinition created as a result of this request
    has_one :content_definition

    validates :title, presence: true

    after_initialize :set_defaults

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
      create_content_definition! content: content
      publish_to_remote

      update_attributes published_at: published_at,
        status: "published"
    end

    def published?
      published_at.present?
    end

    def publish_to_remote
      raise "ERROR: Attempt to publish an unapproved definition" unless approved?
      content_management_grpc.create_content_definition request_proto
    end

    private

    def request_proto
      ::Riddler::Protobuf::CreateContentDefinitionRequest.new \
        content_definition: content_definition.to_proto
    end

    def content_management_grpc
      ::Riddler::Protobuf::ContentManagement::Stub.new \
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

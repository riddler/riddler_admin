require "riddler/protobuf/content_management_services_pb"

module RiddlerAdmin
  class Slug < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "sl".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    belongs_to :content_definition

    validates :name, presence: true, uniqueness: true,
      format: {
        with: /\A[a-z][a-zA-Z0-9_]*\z/,
        message: "must be a valid variable name (no spaces, start with character)"
      }

    validates :status, presence: true, inclusion: {
      in: %w[ live paused ],
      message: "%{value} must be 'live' or 'paused'" }

    validates :target_predicate, parseable_predicate: true

    after_create :create_remote
    after_update :update_remote

    def create_remote
      content_management_grpc.create_slug create_request_proto
    end

    def update_remote
      content_management_grpc.update_slug update_request_proto
    end

    def to_proto
      proto = ::Riddler::Protobuf::Slug.new \
        id: id,
        created_at: timestamp_proto(created_at),
        updated_at: timestamp_proto(updated_at),
        name: name,
        status: status,
        content_definition_id: content_definition.id,
        interaction_identity: interaction_identity

      proto.target_predicate = target_predicate if target_predicate.present?
      proto
    end

    private

    def timestamp_proto timestamp
      ::Google::Protobuf::Timestamp.new seconds: timestamp.to_i,
        nanos: timestamp.nsec
    end

    def create_request_proto
      ::Riddler::Protobuf::CreateSlugRequest.new slug: to_proto
    end

    def update_request_proto
      ::Riddler::Protobuf::UpdateSlugRequest.new slug: to_proto
    end

    def content_management_grpc
      ::Riddler::Protobuf::ContentManagement::Stub.new \
        ::RiddlerAdmin.configuration.riddler_grpc_address,
        :this_channel_is_insecure
    end
  end
end

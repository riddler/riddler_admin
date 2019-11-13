require "riddler/protobuf/content_version_pb"
require "riddler/protobuf/content_management_services_pb"

module RiddlerAdmin
  class ContentVersion < ::RiddlerAdmin::ApplicationRecord
    MODEL_KEY = "cver".freeze
    CARDINALITY = :small

    DEFINITION_SCHEMA_VERSION = 1

    # The Step or Element being defined
    belongs_to :content, polymorphic: true

    # The PublishRequest that created this
    belongs_to :publish_request

    validates :definition, presence: true

    validates_uniqueness_of :version, scope: [:content_type, :content_id]

    before_validation :add_fields

    def description
      publish_request.title
    end

    def title
      "#{content.title} v#{version} - #{description}"
    end

    def to_proto
      ::Riddler::Protobuf::ContentVersion.new \
        id: id,
        created_at: created_at_proto,
        content_type: content.content_type,
        content_id: content.id,
        title: content.title,
        description: description,
        version: version,
        definition_schema_version: DEFINITION_SCHEMA_VERSION,
        definition_string: definition.to_json
    end

    def publish_to_remote
      content_management_grpc.create_content_version create_request_proto
    end

    private

    def created_at_proto
      ::Google::Protobuf::Timestamp.new seconds: created_at.to_i,
        nanos: created_at.nsec
    end

    def create_request_proto
      ::Riddler::Protobuf::CreateContentVersionRequest.new \
        content_version: self.to_proto
    end

    def content_management_grpc
      ::Riddler::Protobuf::ContentManagement::Stub.new \
        ::RiddlerAdmin.configuration.riddler_grpc_address,
        :this_channel_is_insecure
    end

    def add_fields
      return if self.persisted? || content.blank?

      self.definition_schema_version = DEFINITION_SCHEMA_VERSION
      self.version = next_version
      self.definition = generate_definition self.version
    end

    def next_version
      previous_max = self.class.where(content: content).maximum(:version) || 0
      previous_max + 1
    end

    def generate_definition version
      generated_definition = content.definition_hash.merge({
        "definition_id" => id,
        "definition_schema_version" => DEFINITION_SCHEMA_VERSION,
        "version" => version
      })
    end
  end
end

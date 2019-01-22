require "riddler/protobuf/definition_pb"

module RiddlerAdmin
  class Definition < ApplicationRecord
    MODEL_KEY = "cdef".freeze
    ID_LENGTH = 5 # 916_132_832 per second

    DEFINITION_SCHEMA_VERSION = 1

    # The Step or Element being defined
    belongs_to :content, polymorphic: true

    # The PublishRequest that created this
    belongs_to :publish_request

    validates :definition, presence: true

    validates_uniqueness_of :version, scope: [:content_type, :content_id]

    before_validation :add_fields

    def title
      "#{content.title} v#{version}"
    end

    def to_proto
      ::Riddler::Protobuf::Definition.new \
        schema_version: DEFINITION_SCHEMA_VERSION,
        id: id,
        created_at: created_at_proto,
        content_type: content.content_type,
        content_id: content.id,
        version: version,
        definition_json: definition.to_json
    end

    private

    def created_at_proto
      ::Google::Protobuf::Timestamp.new seconds: created_at.to_i,
        nanos: created_at.nsec
    end

    def add_fields
      return if self.persisted? || content.blank?

      self.schema_version = DEFINITION_SCHEMA_VERSION
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

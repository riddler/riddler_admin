# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: riddler/protobuf/content_management.proto for package 'riddler.protobuf'

require 'grpc'
require 'riddler/protobuf/content_management_pb'

module Riddler
  module Protobuf
    module ContentManagement
      class Service

        include GRPC::GenericService

        self.marshal_class_method = :encode
        self.unmarshal_class_method = :decode
        self.service_name = 'riddler.protobuf.ContentManagement'

        rpc :CreateContentDefinition, CreateContentDefinitionRequest, CreateContentDefinitionResponse
        rpc :CreateSlug, CreateSlugRequest, CreateSlugResponse
        rpc :UpdateSlug, UpdateSlugRequest, UpdateSlugResponse
      end

      Stub = Service.rpc_stub_class
    end
  end
end

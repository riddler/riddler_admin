module RiddlerAdmin

  class Configuration
    attr_accessor :riddler_grpc_address, :encrypt_preview_contexts,
      :vault_address, :preview_context_transit_key

    def initialize
      @riddler_grpc_address = nil
      @encrypt_preview_contexts = false
      @vault_address = nil
      @preview_context_transit_key = "riddler-admin-preview-context"
    end

    def remote_riddler?
      riddler_grpc_address.to_s.strip != ""
    end

    def encrypt_preview_contexts?
      !!encrypt_preview_contexts
    end
  end

end

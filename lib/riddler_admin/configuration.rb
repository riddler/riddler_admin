module RiddlerAdmin

  class Configuration
    attr_accessor :riddler_grpc_address, :encrypt_preview_contexts

    def initialize
      @riddler_grpc_address = nil
      @encrypt_preview_contexts = false
    end

    def remote_riddler?
      riddler_grpc_address.to_s.strip != ""
    end

    def encrypt_preview_contexts?
      encrypt_preview_contexts
    end
  end

end

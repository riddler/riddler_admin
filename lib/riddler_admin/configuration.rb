module RiddlerAdmin

  class Configuration
    attr_accessor :riddler_grpc_address

    def initialize
      @riddler_grpc_address = nil
    end

    def remote_riddler?
      riddler_grpc_address.to_s.strip != ""
    end
  end

end

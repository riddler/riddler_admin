module RiddlerAdmin

  class Configuration
    attr_accessor :riddler_grpc_address, :encrypt_preview_contexts,
      :vault_address, :preview_context_transit_key,
      :current_user_method, :user_can_approve_block,
      :controller_authorization_block, :app_name, :parent_app_name

    attr_reader :user_class_name, :user_class,
      :base_controller_name, :base_controller

    def initialize
      @riddler_grpc_address = nil
      @encrypt_preview_contexts = false
      @vault_address = nil
      @preview_context_transit_key = "riddler-admin-preview-context"
      @app_name = "Riddler"
    end

    def remote_riddler?
      riddler_grpc_address.to_s.strip != ""
    end

    def encrypt_preview_contexts?
      !!encrypt_preview_contexts
    end

    def user_class_name= name
      @user_class_name = name
      @user_class = name.constantize
    end

    def base_controller_name= name
      @base_controller_name = name
      @base_controller = name.constantize
    end
  end

end

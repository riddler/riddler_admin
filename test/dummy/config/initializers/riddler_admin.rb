::RiddlerAdmin.configure do |c|
  c.riddler_grpc_address = "127.0.0.1:50051"
  # c.encrypt_preview_contexts = true

  c.user_class_name = "::User"
  c.base_controller_name = "::ApplicationController"
  c.current_user_method = "current_user"

  c.main_app_name = "Main App"

  #c.user_can_approve_block = -> (user) {
  #  user && user.role == "admin"
  #}
  #
  #c.user_can_deploy_block = -> (user) {
  #  user && user.role == "admin"
  #}
end

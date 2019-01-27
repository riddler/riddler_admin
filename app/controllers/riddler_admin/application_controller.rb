module RiddlerAdmin
  class ApplicationController < ::RiddlerAdmin.config.base_controller
    before_action :authorize_riddler_admin
    helper_method :riddler_current_user, :riddler_user_can_approve?

    def riddler_current_user
      self.send ::RiddlerAdmin.config.current_user_method
    end

    def riddler_user_can_approve?
      return true if ::RiddlerAdmin.config.user_can_approve_block.nil?
      ::RiddlerAdmin.config.user_can_approve_block.call riddler_current_user
    end

    private

    def authorize_riddler_admin
      return true if ::RiddlerAdmin.config.controller_authorization_block.nil?
      ::RiddlerAdmin.config.controller_authorization_block.call self
    end
  end
end

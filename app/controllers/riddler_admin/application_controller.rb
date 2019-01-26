module RiddlerAdmin
  class ApplicationController < ::RiddlerAdmin.config.base_controller
    helper_method :riddler_current_user, :riddler_user_can_approve?

    def riddler_current_user
      self.send ::RiddlerAdmin.config.current_user_method
    end

    def riddler_user_can_approve?
      return true if ::RiddlerAdmin.config.user_can_approve_block.nil?
      ::RiddlerAdmin.config.user_can_approve_block.call riddler_current_user
    end
  end
end

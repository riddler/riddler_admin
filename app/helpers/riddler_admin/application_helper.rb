module RiddlerAdmin
  module ApplicationHelper
    def current_user
      controller.send ::RiddlerAdmin.config.current_user_method
    end

    def user_can_approve?
      ::RiddlerAdmin.config.user_can_approve_block.call current_user
    end
  end
end

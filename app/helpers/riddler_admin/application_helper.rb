module RiddlerAdmin
  module ApplicationHelper
    def current_user
      controller.send config.current_user_method
    end

    def user_can_approve?
      return true if config.user_can_approve_block.nil?
      config.user_can_approve_block.call current_user
    end

    def config
      ::RiddlerAdmin.config
    end
  end
end

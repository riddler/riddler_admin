module RiddlerAdmin
  class ApplicationController < ::RiddlerAdmin.config.base_controller
    protect_from_forgery with: :exception
  end
end

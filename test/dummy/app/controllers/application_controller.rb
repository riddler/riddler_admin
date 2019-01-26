class ApplicationController < ActionController::Base
  def current_user
    return nil unless session.key? :user_id
    @current_user ||= User.find session[:user_id]
  end
end

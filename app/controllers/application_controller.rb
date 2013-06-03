class ApplicationController < ActionController::Base
  protect_from_forgery
  
  # Include LTI context for accessing it in our views and actions
  include Omniauth::Lti::Context
  
  def current_user=(current_user)
    @current_user = current_user
    session[:current_user] = current_user.uid
  end
  
  def current_user
    @current_user ||= User.find_by_uid session[:current_user]
  end
  
  helper_method :current_user
end

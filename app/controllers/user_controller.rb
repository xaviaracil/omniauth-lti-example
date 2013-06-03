class UserController < ApplicationController
  before_filter :set_lti_credentials
  
  def index
    redirect_to :action => :show and return if self.current_user
    render 'error'
  end

  def show
    render 'error' unless self.current_user  
  end
  
  private 
  
  # set tool consumer credentials in LTI context
  def set_lti_credentials
    self.lti_credentials = LTI_CREDENTIALS_HASH
  end
end

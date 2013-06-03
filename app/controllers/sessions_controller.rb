class SessionsController < ApplicationController
  
  def create
    @user = User.find_or_create_from_auth_hash(auth_hash)
    self.current_user = @user

    # save LTI context for future use
    save_lti_context
    
    redirect_to '/user'
  end
  
  def destroy
    session.destroy
    redirect_to '/'
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end      
end

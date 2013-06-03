OmniAuth LTI Example Application
================================

This web application is a basic web application for demoing the use of the [omniauth-lti][] gem. 

Installation
============

Clone this repository and set up the database with `rake db:migrate`.

Set up a tool\_provider in your LTI consumer with:

* `/sessions/create` as the launch_url
* `test` as the key
* `secret` as the secret

How to add Omniauth-LTI
=======================

The steps done in this application for authenticating using [omniauth-lti][] are:

1. Add the gem
--------------

Add the [omniauth-lti][] gem in you Gemfile:

	gem 'omniauth-lti'
	
Run bundle install for downloading and installing the gem:

	bundle install --without production
	
2. Set up
---------

Edit (or create) an initializer `config/initializers/omniauth.rb`, adding the lti omniauth strategy:

	Rails.application.config.middleware.use OmniAuth::Builder do
	  provider :lti, :oauth_credentials => LTI_CREDENTIALS_HASH
	end
	
Create `config/initializers/lti.rb`, enabling Oauth 1.0 support:

	# You also need to explicitly enable OAuth 1 support in the environment.rb or an initializer:
	OAUTH_10_SUPPORT = true
	
If the credentials of your tool consumers are static, add them here too:

	# Tool consumer credentials
	LTI_CREDENTIALS_HASH = {:test => 'secret'}

Set up the omniauth route, if not set up yet. Edit your `config/routes.rb`, adding the line:
	
	# set the route for omniauth
	post '/auth/:provider/callback', to: 'sessions#create'
	
*Note* that the HTTP method for the route is POST.
*Note* that there is no request phase in this authentication mechanism. That is because LTI spec defines the 
authentication from the LTI consumer to the LTI provider (this webapp).

3. Include Module
-----------------

Include `Omniauth::Lti::Context` in your `application_controller.rb`:

	class ApplicationController < ActionController::Base
	  ...

	  # Include LTI context for accessing it in our views and actions
	  include Omniauth::Lti::Context

	  ...
	end

4. Save and use the context
---------------------------

If you want to use the LTI context in your application, first you'll have to save it. 
Call `save_lti_contex`t when you are creating the sessions (typically in `SessionsController\#create` in a normal Omniauth application)

The context is saved for use anywhere in your application, just call

	lti_tool_provider
	
for retriving it. For instance, in `app/views/user/show.html.haml`:

	%p
		This application has been launched from 
		%code
			=lti_tool_provider.resource_link_title
			(
			=lti_tool_provider.resource_link_id
			)
	%p
		The key used for the tool_provider is
		%code=lti_tool_provider.consumer_key
		and the secret is
		%code=lti_tool_provider.consumer_secret	

*Get the secret* In order to get the consumer\_secret, needed for making outcome calls, you'll have to pass 
to the LTI context a hash of tool\_consumer credentials, where the key is the consumer\_key and the value is the consumer\_secret.

To pass this hash you'll have to call `lti_credentials=` in your controller, as below:

	class UserController < ApplicationController
	  before_filter :set_lti_credentials
  
      ... 

	  private 
  
	  # set tool consumer credentials in LTI context
	  def set_lti_credentials
	    self.lti_credentials = LTI_CREDENTIALS_HASH
	  end
	end


[omniauth-lti]: https://github.com/xaviaracil/omniauth-lti
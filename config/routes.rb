OmniauthLtiExample::Application.routes.draw do
  get "user", to: 'user#index'
  get "user/show"
  
  # set the route for omniauth
  post '/auth/:provider/callback', to: 'sessions#create'
end

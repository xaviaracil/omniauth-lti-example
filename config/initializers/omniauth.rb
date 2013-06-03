Rails.application.config.middleware.use OmniAuth::Builder do
  provider :lti, :oauth_credentials => LTI_CREDENTIALS_HASH
end
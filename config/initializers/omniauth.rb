require 'omniauth-tradegecko'
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :tradegecko, ENV["OAUTH_ID"], ENV["OAUTH_SECRET"]
end

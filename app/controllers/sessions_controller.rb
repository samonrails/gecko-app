class SessionsController < ApplicationController
  def create
    user = User.where(provider: auth["provider"], uid: auth["uid"].to_s).first || User.create_with_omniauth(auth)
    token = OAuth2::AccessToken.new(oauth_client, auth["credentials"]["token"], auth["credentials"].slice("refresh_token", "expires_at"))
    session[:user_id] = user.id
    set_session_from_access_token(token)
    redirect_to root_url
  end

  def destroy
    clear_session
    redirect_to root_url
  end

private
  def auth
    request.env["omniauth.auth"]
  end
end

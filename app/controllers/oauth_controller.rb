class OauthController < ApplicationController
  before_filter :authenticate_user!

  def sync
  end

  def callback
    auth_hash = request.env['omniauth.auth']

    provider = auth_hash['provider']
    token = auth_hash['credentials']['token']
    expires = auth_hash['credentials']['expires']
    expires_at = auth_hash['credentials']['expires_at']

    current_user.create_or_update_omniauth(
      provider, token, expires, expires_at
    )

    redirect_to '/account/sync'
  end

  def unbind
    current_user.unbind_omniauth(params[:provider])
    redirect_to '/account/sync'
  end
end
class OauthController < ApplicationController
  before_filter :authenticate_user!

  def sync
  end

  def callback
    auth_hash = request.env['omniauth.auth']
    current_user.create_or_update_omniauth(auth_hash)
    redirect_to '/account/sync'
  end

  def unbind
    current_user.unbind_omniauth(params[:provider])
    redirect_to '/account/sync'
  end
end
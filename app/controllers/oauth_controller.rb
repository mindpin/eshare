class OauthController < ApplicationController
  before_filter :authenticate_user!, :except => [:callback]

  layout 'account'

  def sync
  end

  def callback
    oauth_hash = request.env['omniauth.auth']
    if user_signed_in?
      current_user.create_or_update_omniauth(oauth_hash)
      redirect_to '/account/sync'
    else
      user = User.create_oauth_sign_user(oauth_hash)
      sign_in(:user, user)

      redirect_to '/'
    end
  end

  def unbind
    current_user.unbind_omniauth(params[:provider])
    redirect_to '/account/sync'
  end
end
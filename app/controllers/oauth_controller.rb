class OauthController < ApplicationController
  before_filter :authenticate_user!, :except => [:callback]

  layout 'account'

  def sync
  end

  def callback
    oauth_hash = request.env['omniauth.auth']
    if user_signed_in?
      omniauth = current_user.create_or_update_omniauth(oauth_hash)
      if omniauth.id.blank?
        provider = omniauth['provider']
        flash[:error] = "尝试绑定 #{provider} 失败，此 #{provider} 账号可能已被其他本站用户绑定"
      end
      redirect_to '/account/sync'
    else
      user = User.create_of_find_oauth_sign_user(oauth_hash)
      sign_in(:user, user)

      redirect_to after_sign_in_path_for(user)
    end
  end

  def unbind
    current_user.unbind_omniauth(params[:provider])
    redirect_to '/account/sync'
  end
end
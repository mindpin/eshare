# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  def index
    if !user_signed_in?
      return redirect_to '/account/sign_in'
    end

    if current_user.is_admin?
      return redirect_to "/admin"
    end
    
    redirect_to '/dashboard'
  end

  def dashboard
    # 教师和学生的工作台页面
  end

  def faye_auth
    user_id = current_user ? current_user.id : -1
    render :json => {:user_id => user_id}
  end
end

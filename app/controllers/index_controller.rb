# -*- coding: utf-8 -*-
class IndexController < ApplicationController
  before_filter :login_required
  
  def index
    if current_user.is_admin?
      return redirect_to "/admin"
    end
    redirect_to '/dashboard'
  end

  def dashboard
    # 教师和学生的工作台页面
  end
end

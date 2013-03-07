# -*- coding: utf-8 -*-
module SessionsControllerMethods
  # 登录
  def new
    return redirect_back_or_default('/') if logged_in?
    return render :template=>'auth/index/login'
  end
  
  def create
    self.current_user = User.authenticate(params[:email], params[:password])

    # ajax 登录
    if request.xhr?
      if logged_in?
        after_logged_in()
        render :status=>200, :json=>{:result=>'ok', :redirect_to=>"/"}
      else
        render :status=>401, :text=>'登录失败：邮箱/密码不正确'
      end
      return
    end

    # 普通登录
    if logged_in?
      after_logged_in()
      redirect_back_or_default('/')
    else
      flash_error '登录失败：邮箱/密码不正确'
      redirect_to '/'
    end
  end
  
  # 登出
  def destroy
    user = current_user
    
    if user
      reset_session_with_online_key()
      # 登出时销毁cookies令牌
      destroy_remember_me_cookie_token()
      destroy_online_record(user)
    end
    
    return redirect_to "/auth/login"
  end
  
end

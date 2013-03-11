class Auth::SettingController <  ApplicationController
  before_filter :authenticate_user!

  # 基本信息
  def base
  end

    # 修改基本信息
  def base_submit
    @user= current_user

    @user.name = params[:name]
    if @user.save
      flash[:success] = "用户信息修改成功"
    else
      flash_error(@user)
    end
    return redirect_to :action => :base
  end

  # -------------- 密码部分
  def password;end

  def password_submit
    @user = current_user
    u = User.authenticate(@user.email,params[:old_password])
    if u.blank? || u != @user
      flash[:error] = "旧密码输入错误"
      return redirect_to :action => :password
    end

    @user.password = params[:new_password]
    @user.password_confirmation = params[:new_password_confirmation]

    if @user.save
      flash[:success] = "密码修改成功"
    else
      flash_error(@user)
    end
    redirect_to :action => :password
  end
end

class AccountController < Devise::RegistrationsController
  layout Proc.new { |controller|
    case controller.action_name
    when 'new'
      return 'auth'
    when 'edit'
      return 'account'
    else
      return 'account'
    end
  }

  def new
    super
    # 在这里添加其他逻辑
  end

  def edit
    super
    # 在这里添加其他逻辑
  end

  def avatar
  end

  def avatar_update
    user = User.find(current_user.id)
    user.avatar = params[:user][:avatar]
    user.save
    redirect_to :action => :avatar
  # rescue Exception => ex
  #   flash[:error] = ex.message
  #   return redirect_to :action => :avatar
  end

  protected

    def after_update_path_for(resource)
      '/account/edit'
    end
end
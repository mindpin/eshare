class AccountController < Devise::RegistrationsController
  layout 'auth', :only => [:new]

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
    current_user.update_attributes(params[:user])
    redirect_to :action => :avatar
  rescue Exception => ex
    flash[:error] = ex.message
    return redirect_to :action => :avatar
  end

  protected

    def after_update_path_for(resource)
      '/account/edit'
    end
end
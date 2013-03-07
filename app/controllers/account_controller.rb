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

  protected

    def after_update_path_for(resource)
      '/account/edit'
    end
end
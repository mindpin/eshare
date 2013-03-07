class AccountController < Devise::RegistrationsController
  layout 'auth', :only => [:new]

  def new
    super
    # 在这里添加其他逻辑
  end
end
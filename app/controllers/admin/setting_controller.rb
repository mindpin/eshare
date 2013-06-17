class Admin::SettingController < Devise::RegistrationsController
  before_filter :authenticate_user!
  layout 'admin'

  def password
    @user = current_user
  end

  def change_password
    @user = current_user
    if params[:user][:current_password].blank?
      @user.errors.add(:current_password, :blank)
      return render :password
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.save
      return redirect_to '/admin/setting/password'
    else
      return render :password
    end
  end
end
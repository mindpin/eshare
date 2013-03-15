class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.page params[:page]
  end

  def edit
    @user = User.find(params[:id])
  end

  def student_attrs
    @user = User.find(params[:id])
    redirect_if_not(@user, :student)
  end

  def teacher_attrs
    @user = User.find(params[:id])
    redirect_if_not(@user, :teacher)
  end

  def user_attrs_update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.save
    redirect_to user_attrs_path(@user)
  end

protected

  def redirect_if_not(user, role)
    redirect_to admin_root_path if !user.role?(role)
  end

  def user_attrs_path(user)
    return student_attrs_admin_user_path(user) if user.role? :student
    teacher_attrs_admin_user_path(user)
  end
end

class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  def index
    @users = User.page(params[:page]).order('id DESC').like_filter(@query = params[:q])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    _update_user(:change_base_info)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy
    redirect_to :action => :index
  end

  # ---------------

  def change_password
    _update_user(:change_password)
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

  def download_import_sample
    send_file User.get_sample_excel_student, :filename => 'user_sample.xlsx'
  end

  def import

  end

  def do_import
    file = params[:excel_file]
    User.import_excel(file, :student, '1234')
    redirect_to :action => :index
  end

protected

  def redirect_if_not(user, role)
    redirect_to admin_root_path if !user.role?(role)
  end

  def user_attrs_path(user)
    return student_attrs_admin_user_path(user) if user.role? :student
    teacher_attrs_admin_user_path(user)
  end

private

  def _update_user(as)
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => as)
      return redirect_to "/admin/users/#{@user.id}/edit"
    end
    render :action => :edit
  end
end

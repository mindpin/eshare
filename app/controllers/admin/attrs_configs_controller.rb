class Admin::AttrsConfigsController < ApplicationController
  before_filter :authenticate_user!
  layout 'admin'

  def new
    @config = AttrsConfig.new(:role => params[:role])
  end

  def edit
    @config = AttrsConfig.find(params[:id])
  end

  def create
    @config = AttrsConfig.new(params[:attrs_config])
    return redirect_to send("#{@config.role}_attrs_admin_attrs_configs_path") if @config.save
    redirect_to :back
  end

  def teacher_attrs
    @configs = AttrsConfig.where(:role => :teacher)
  end

  def student_attrs
    @configs = AttrsConfig.where(:role => :student)
  end

  def update
    @config = AttrsConfig.find(params[:id])
    return redirect_to send("#{@config.role}_attrs_admin_attrs_configs_path") if @config.update_attributes(params[:attrs_config])
    redirect_to :back
  end
end
class Manage::AppliesController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end
  
  def index
    applies = SelectCourseApply.page(params[:page])
    applies.each do |apply|
      apply.destroy if apply.course.blank?
    end
    @applies = SelectCourseApply.page(params[:page])
  end

  def status_request
    @applies = SelectCourseApply.by_status(SelectCourseApply::STATUS_REQUEST).page(params[:page])
    render :action => :index
  end

  def status_accept
    @applies = SelectCourseApply.by_status(SelectCourseApply::STATUS_ACCEPT).page(params[:page])
    render :action => :index
  end

  def status_reject
    @applies = SelectCourseApply.by_status(SelectCourseApply::STATUS_REJECT).page(params[:page])
    render :action => :index
  end
end
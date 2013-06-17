class Manage::AppliesController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end
  
  def index
    @course = Course.find(params[:course_id])
    @applies = @course.select_course_applies
  end

  def accept
    @apply = SelectCourseApply.find(params[:id])
    @apply.status = SelectCourseApply::STATUS_ACCEPT
    @apply.save

    redirect_to "/manage/courses/#{@apply.course.id}/applies"
  end

  def reject
    @apply = SelectCourseApply.find(params[:id])
    @apply.status = SelectCourseApply::STATUS_REJECT
    @apply.save

    redirect_to "/manage/courses/#{@apply.course.id}/applies"
  end
end
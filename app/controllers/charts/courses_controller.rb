class Charts::CoursesController < ApplicationController
  before_filter :authenticate_user!
  
  def all_courses_read_pie
    render :json => current_user.course_read_stat
  end

  def all_courses_punch_card
    @stat = current_user.course_weekdays_stat
    render :layout => false
  end

  def read_pie
    @course = Course.find params[:id]
    render :json => @course.course_wares_read_stat_of(current_user)
  end

  def all_courses_select_apply_pie
    render :json => SelectCourseApply.course_status_stat
  end
end
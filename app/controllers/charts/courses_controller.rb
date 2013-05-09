class Charts::CoursesController < ApplicationController
  before_filter :authenticate_user!
  
  def all_courses_read_pie
    render :json => current_user.course_read_stat
  end

  def all_courses_punch_card
    @stat = current_user.course_weekdays_stat
    render :layout => false
  end
end
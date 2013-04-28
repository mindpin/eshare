class Charts::CourseWaresController < ApplicationController
  before_filter :authenticate_user!

  def read_count_last_week
    @course_ware = CourseWare.find params[:id]
    render :json => @course_ware.last_week_read_count_changes_of(current_user)
  end
end
class Manage::Aj::CoursesController < ApplicationController
  layout 'course_manage_aj'

  def show
    @course = Course.find params[:id]
  end
end
class CourseWaresController < ApplicationController
  def show
    @course_ware = CourseWare.find params[:id]
  end
end
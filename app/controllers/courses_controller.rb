class CoursesController < ApplicationController
  before_filter :pre_load

  def pre_load
    @course = Course.find(params[:id]) if params[:id]
  end

  def index
    @courses = Course.page(params[:page])
  end

  def show
    @chapters = @course.chapters.page(params[:page])
  end

  def manage
    @courses = current_user.courses.page(params[:page])
  end

  def manage_one
  end
end
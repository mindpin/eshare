class Manage::CoursesController < ApplicationController
  def index
    @courses = Course.page(params[:page])
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.build(params[:course])
    if @course.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def show
    @course = Course.find params[:id]
    @chapters = @course.chapters
  end
end
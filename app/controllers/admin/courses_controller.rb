class Admin::CoursesController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!
  before_filter :pre_load

  
  def pre_load
    @course = Course.find(params[:id]) if params[:id]
  end


  def index
    @courses = Course.page params[:page]
  end


  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.build(params[:course])
    if @course.save
      redirect_to "/admin/courses/#{@course.id}"
    end
  end

  def show
  end

  def edit
  end

  def update
    @course.update_attributes(params[:course])

    redirect_to "/admin/courses/#{@course.id}"
  end

  def destroy
    @course.destroy

    redirect_to "/admin/courses"
  end
end
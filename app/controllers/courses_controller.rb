class CoursesController < ApplicationController
  before_filter :pre_load

  def pre_load
    @course = Course.find(params[:id]) if params[:id]
  end

  def manage
    @courses = current_user.courses.page(params[:page])
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.build(params[:course])
    if @course.save
      return redirect_to :action => :manage
    end
    render :action => :new
  end

  def edit
  end

  def update
    if @course.update_attributes(params[:course])
      return redirect_to :action => :index
    end
    render :action => :edit
  end

  # -------------

  def show
  end

  def destroy
    @course.destroy
    redirect_to :action => :index
  end


  def import
  end

  def do_import
    file = params[:excel_file]
    Course.import(file, current_user)

    redirect_to :action => :index
  end
end
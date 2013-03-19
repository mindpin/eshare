class CourseWaresController < ApplicationController
  before_filter :authenticate_user!

  def new
    @course_ware = CourseWare.new
  end

  def create
    @course_ware = CourseWare.new(params[:course_ware])
    @course_ware.creator = current_user
    if @course_ware.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def edit
    @course_ware = CourseWare.find(params[:id])
  end

  def update
    @course_ware = CourseWare.find(params[:id])
    if @course_ware.save
      return redirect_to :action => :index
    end
    render :action => :edit
  end

  def destroy
    @course_ware = CourseWare.find(params[:id])
    @course_ware.destroy
    return redirect_to :action => :index
  end

end
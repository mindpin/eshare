class CourseWaresController < ApplicationController
  before_filter :authenticate_user!

  def index
    @chapter = Chapter.find(params[:chapter_id])
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
    @course_ware = CourseWare.new
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @course_ware = @chapter.course_wares.build(params[:course_ware])
    @course_ware.creator = current_user
    if @course_ware.save
      return redirect_to "/chapters/#{@chapter.id}/course_wares"
    end
    render :action => :new
  end

  def edit
    @course_ware = CourseWare.find(params[:id])
  end

  def update
    @course_ware = CourseWare.find(params[:id])
    if @course_ware.update_attributes(params[:course_ware])
      return redirect_to "/chapters/#{@course_ware.chapter_id}/course_wares"
    end
    render :action => :edit
  end

  def destroy
    @course_ware = CourseWare.find(params[:id])
    @course_ware.destroy
    return redirect_to "/chapters/#{@course_ware.chapter_id}/course_wares"
  end

end
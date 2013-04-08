class Manage::ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find params[:id]
    @course = @chapter.course
    @course_wares = @chapter.course_wares
  end

  def new
    @course = Course.find(params[:course_id])
    @chapter = @course.chapters.new
  end

  def create
    @course = Course.find(params[:course_id])
    @chapter = @course.chapters.build(params[:chapter])
    @chapter.creator = current_user
    if @chapter.save
      return redirect_to "/manage/courses/#{@course.id}"
    end
    render :action => :new
  end

  def edit
    @chapter = Chapter.find(params[:id])
    @course = @chapter.course
  end


  def update
    @chapter = Chapter.find(params[:id])
    @course = @chapter.course
    if @chapter.update_attributes params[:chapter]
      return redirect_to "/manage/courses/#{@course.id}"
    end
    render :action => :edit, :id => @chapter.id
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    @course = @chapter.course
    @chapter.destroy
    redirect_to "/manage/courses/#{@course.id}"
  end
end
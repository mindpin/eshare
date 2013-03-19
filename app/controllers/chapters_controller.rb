class ChaptersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @course = Course.find(params[:course_id])
    @chapters = @course.chapters
  end

  def new
    @course = Course.find(params[:course_id])
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def create
    @course = Course.find(params[:course_id])
    @chapter = @course.chapters.build(params[:chapter])
    @chapter.creator = current_user
    if @chapter.save
      return redirect_to "/courses/#{@course.id}/chapters"
    end
    render :action => :new
  end

  def show
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    if @chapter.update_attributes params[:chapter]
      return redirect_to "/courses/#{@chapter.course_id}/chapters"
    end
    render :action => :edit, :id => @chapter.id
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    @chapter.destroy
    redirect_to :action => :index, :course_id => @chapter.course_id
  end
end
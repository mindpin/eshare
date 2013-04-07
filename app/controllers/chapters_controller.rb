class ChaptersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @course = Course.find(params[:course_id])
    @chapters = @course.chapters
  end

  def show
    @chapter = Chapter.find(params[:id])
    @course = @chapter.course
    @course_wares = @chapter.course_wares
  end
end
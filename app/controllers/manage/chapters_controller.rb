class Manage::ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find params[:id]
    @course = @chapter.course
    @course_wares = @chapter.course_wares
  end
end
class CourseWaresController < ApplicationController
  layout 'course_ware_show', :only => [:show]

  def show
    @course_ware = CourseWare.find params[:id]
    @chapter = @course_ware.chapter
    @course = @chapter.course
    @questions = @chapter.questions.page(params[:page]).per(10)
  end
end
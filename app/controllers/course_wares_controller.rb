class CourseWaresController < ApplicationController
  layout 'course_ware_show', :only => [:show]

  def show
    @course_ware = CourseWare.find params[:id]
    @chapter = @course_ware.chapter
    @course = @chapter.course
    @questions = @chapter.questions.page(params[:page]).per(10)
  end

  def update_read_count
    @course_ware = CourseWare.find params[:id]
    @course_ware.update_read_count_of current_user, params[:read_count].to_i
    render :text => params[:read_count]
  end
end
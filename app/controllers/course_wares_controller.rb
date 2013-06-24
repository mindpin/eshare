class CourseWaresController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  layout 'course_ware_show', :only => [:show]

  def show
    @course_ware = CourseWare.find params[:id]
    @course_ware.refresh_total_count!
    
    @chapter = @course_ware.chapter
    @course = @chapter.course
    @questions = @course_ware.questions.page(params[:page]).per(10)
  end

  def update_read_count
    @course_ware = CourseWare.find params[:id]
    @course_ware.update_read_count_of current_user, params[:read_count].to_i
    render :text => params[:read_count]
  end

  def add_video_mark
    @course_ware = CourseWare.find params[:id]
    mark = @course_ware.course_ware_marks.create :user => current_user,
                                          :content => params[:content],
                                          :position => params[:position]
    render :json => {
      :content => mark.content,
      :position => mark.position,
      :user_name => mark.user.name,
      :avatar_url => mark.user.avatar.versions[:small].url
    }
  end

  def show_javascript_steps
    render "/javascript_steps/show"
  end
end
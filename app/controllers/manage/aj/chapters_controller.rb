class Manage::Aj::ChaptersController < ApplicationController
  layout 'course_manage_aj'

  def show
    @chapter = Chapter.find params[:id]
    @course = @chapter.course

    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def new
    @course = Course.find params[:course_id]
    @chapter = @course.chapters.new

    if request.headers['X-PJAX']
      render :layout => false
    end
  end

  def create
    @course = Course.find(params[:course_id])
    @chapter = @course.chapters.build(params[:chapter])
    @chapter.creator = current_user
    if @chapter.save
      return redirect_to "/manage/aj/chapters/#{@chapter.id}"
    end
    render :action => :new
  end
end
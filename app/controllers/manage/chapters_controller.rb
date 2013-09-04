class Manage::ChaptersController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end
  
  def show
    @chapter = Chapter.find params[:id]
    authorize! :manage, @chapter
    @course = @chapter.course
    @course_wares = @chapter.course_wares
  end

  def new
    authorize! :manage, Chapter
    @course = Course.find(params[:course_id])
    @chapter = @course.chapters.new
  end

  def create
    authorize! :manage, Chapter
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
    authorize! :manage, @chapter
    @course = @chapter.course
  end


  def update
    @chapter = Chapter.find(params[:id])
    authorize! :manage, @chapter
    @course = @chapter.course
    if @chapter.update_attributes params[:chapter]
      return redirect_to "/manage/courses/#{@course.id}"
    end
    render :action => :edit, :id => @chapter.id
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    authorize! :manage, @chapter
    @course = @chapter.course
    @chapter.destroy

    if request.xhr?
      return render :json => {:status => 'ok'}
    end

    redirect_to "/manage/courses/#{@course.id}"
  end

  def move_up
    @chapter = Chapter.find(params[:id])
    authorize! :manage, @chapter
    @course = @chapter.course
    @chapter.move_up

    if request.xhr?
      return render :json => {
        :status => 'ok',
        :html => (render_cell :course_ware, :manage_chapter_table, :chapters => [@chapter])
      }
    end

    return redirect_to "/manage/courses/#{@course.id}"
  end

  def move_down
    @chapter = Chapter.find(params[:id])
    authorize! :manage, @chapter
    @course = @chapter.course
    @chapter.move_down

    if request.xhr?
      return render :json => {
        :status => 'ok',
        :html => (render_cell :course_ware, :manage_chapter_table, :chapters => [@chapter])
      }
    end

    return redirect_to "/manage/courses/#{@course.id}"
  end
end
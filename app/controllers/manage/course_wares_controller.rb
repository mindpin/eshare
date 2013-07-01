class Manage::CourseWaresController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end
  
  def index
    @chapter = Chapter.find(params[:chapter_id])
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
    @course_ware = @chapter.course_wares.new

    @for_web_video = params[:for] == 'web_video'

    if R::INTERNET
      @for_javascript = params[:for] == 'javascript'
    end
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @course_ware = @chapter.course_wares.build(params[:course_ware], :as => :upload)
    @course_ware.creator = current_user
    if @course_ware.save
      return redirect_to "/manage/chapters/#{@chapter.id}"
    end
    render :action => :new
  end

  def edit
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    @select_chapters = @chapter.course.chapters
  end

  def update
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    if @course_ware.update_attributes(params[:course_ware], :as => :upload)
      return redirect_to "/manage/chapters/#{@chapter.id}"
    end
    render :action => :edit
  end

  def destroy
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    @course_ware.destroy
    return redirect_to "/manage/chapters/#{@chapter.id}"
  end

  def move_up
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    @course_ware.move_up
    return redirect_to "/manage/chapters/#{@chapter.id}"
  end

  def move_down
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    @course_ware.move_down
    return redirect_to "/manage/chapters/#{@chapter.id}"
  end

  def do_convert
    @course_ware = CourseWare.find(params[:id])
    @chapter = @course_ware.chapter
    
    @course_ware.file_entity.do_convert(true)

    return redirect_to "/manage/chapters/#{@chapter.id}"
  end

end
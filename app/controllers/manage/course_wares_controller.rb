class Manage::CourseWaresController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'admin' if current_user.is_admin?
    'application'
  end
  
  def index
    @chapter = Chapter.find(params[:chapter_id])
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
    @course_ware = @chapter.course_wares.new

    @for_web_video = params[:for] == 'web_video'
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

  def new_javascript_steps
    render '/javascript_steps/new.html.haml'
  end

  def create_javascript_steps
    chapter = Chapter.find(params[:chapter_id])
    course_ware = chapter.course_wares.build(:title => 'javascript steps', :creator => current_user)
    course_ware.kind = 'javascript'
    course_ware.save
    course_ware.javascript_steps.create(:content => 'js1', :rule => "1")
    course_ware.javascript_steps.create(:content => 'js2', :rule => "2")
    course_ware.javascript_steps.create(:content => 'js3', :rule => "3")
    course_ware.javascript_steps.create(:content => 'js4', :rule => "4")
    course_ware.javascript_steps.create(:content => 'js5', :rule => "5")
    redirect_to "/course_wares/#{course_ware.id}/show_javascript_steps"
  end
end

class Manage::CoursesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @courses = Course.page(params[:page])
  end

  def new
    @course = Course.new
  end

  def create
    @course = current_user.courses.build(params[:course])
    if @course.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def edit
    @course = Course.find params[:id]
  end

  def update
    @course = Course.find params[:id]
    if @course.update_attributes(params[:course])
      return redirect_to :action => :index
    end
    render :action => :edit
  end

  def show
    @course = Course.find params[:id]
    @chapters = @course.chapters
  end

  def destroy
    @course = Course.find params[:id]
    @course.destroy
    redirect_to :action => :index
  end

  def download_import_sample
    send_file Course.get_sample_excel_course, :filename => 'course_sample.xlsx'
  end

  def import
  end

  def do_import
    file = params[:excel_file]
    # render :text => File.extname(file.original_filename)
    Course.import(file, current_user)

    redirect_to :action => :index
  end

  def import_youku_list
  end

  def import_youku_list_2
    @url = params[:url]
    @data = YoukuVideoList.new(@url).parse
  end

  def do_import_youku_list
    @url = params[:url]
    Course.import_youku_video_list(@url, current_user)

    redirect_to :action => :index
  end
end
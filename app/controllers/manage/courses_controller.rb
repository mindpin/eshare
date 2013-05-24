class Manage::CoursesController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'admin' if current_user.is_admin?
    return 'manage'
  end
  
  def index
    if (query = @query = params[:q]).blank?
      @courses = Course.page(params[:page])
    else
      @courses = @search = Course.search {
        fulltext query
      }.results
    end
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
    tags = params[:course_tags]

    if @course.update_attributes(params[:course]) && 
       @course.replace_public_tags(tags, current_user)
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

  def import_tudou_list
  end

  def import_tudou_list_2
    @url = params[:url]
    @data = TudouVideoList.new(@url).parse
  end

  def do_import_tudou_list
    @url = params[:url]
    Course.import_tudou_video_list(@url, current_user)

    redirect_to :action => :index
  end
end
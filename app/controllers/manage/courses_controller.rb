class Manage::CoursesController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end
  
  def index
    authorize! :manage, Course
    if (query = @query = params[:q]).blank?
      @courses = Course.page(params[:page])
    else
      @courses = @search = Course.search {
        fulltext query
      }.results
    end
  end

  def new
    authorize! :manage, Course
    @course = Course.new
  end

  def create
    authorize! :manage, Course
    @course = current_user.courses.build(params[:course])
    if @course.save
      tags = params[:course_tags]
      if tags.present?
        @course.replace_public_tags(tags, current_user)
      end
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def edit
    @course = Course.find params[:id]
    authorize! :manage, @course
  end

  def update
    @course = Course.find params[:id]
    authorize! :manage, @course
    tags = params[:course_tags]

    if @course.update_attributes(params[:course]) && 
       @course.replace_public_tags(tags, current_user)
      return redirect_to :action => :index
    end
    render :action => :edit
  end

  def show
    @course = Course.find params[:id]
    authorize! :manage, @course
    @chapters = @course.chapters
  end

  def destroy
    @course = Course.find params[:id]
    authorize! :manage, @course
    @course.destroy

    if params[:q].present?
      redirect_to :action => :index, :q => params[:q]
    else
      redirect_to :action => :index
    end
  end

  def download_import_sample
    authorize! :manage, Course
    send_file Course.get_sample_excel_course, :filename => 'course_sample.xlsx'
  end

  def import
    authorize! :manage, Course
  end

  def do_import
    authorize! :manage, Course
    file = params[:excel_file]
    Course.import(file, current_user)
    redirect_to :action => :index
  end

  def import_youku_list
    authorize! :manage, Course
  end

  def import_youku_list_2
    authorize! :manage, Course
    @url = params[:url]
    @data = YoukuVideoList.new(@url).parse
  end

  def do_import_youku_list
    authorize! :manage, Course
    @url = params[:url]
    Course.import_youku_video_list(@url, current_user)

    redirect_to :action => :index
  end

  def import_tudou_list
    authorize! :manage, Course
  end

  def import_tudou_list_2
    authorize! :manage, Course
    @url = params[:url]
    @data = TudouVideoList.new(@url).parse
  end

  def do_import_tudou_list
    authorize! :manage, Course
    @url = params[:url]
    Course.import_tudou_video_list(@url, current_user)

    redirect_to :action => :index
  end
end
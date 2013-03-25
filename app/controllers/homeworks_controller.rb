class HomeworksController < ApplicationController
  before_filter :authenticate_user!

  def index
    @chapter = Chapter.find(params[:chapter_id])
    @homeworks = @chapter.homeworks
  end

  def new
    @chapter = Chapter.find(params[:chapter_id])
    @homework = @chapter.homeworks.build

    @homework.homework_requirements.build
    @homework.homework_requirements.build

    @homework.homework_attaches.build
    @homework.homework_attaches.build
  end

  def create
    @chapter = Chapter.find(params[:chapter_id])
    @homework = @chapter.homeworks.new(params[:homework])
    @homework.creator = current_user
    if @homework.save
      return redirect_to "/chapters/#{@chapter.id}/homeworks"
    end
    render :action => :new
  end

  def show
    @homework = Homework.find(params[:id])
  end

end
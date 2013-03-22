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
  end

  def create
  end
end
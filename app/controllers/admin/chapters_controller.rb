class Admin::ChaptersController < ApplicationController
  layout 'admin'

  def index
    @chapters = Chapter.all
  end

  def new
    @chapter = Chapter.new
  end

  def edit
    @chapter = Chapter.find(params[:id])
  end

  def create
    @chapter = Chapter.new(params[:chapter])
    return redirect_to admin_chapter_path(@chapter) if @chapter.save
    redirect_to :action => :new
  end
  def show
    @chapter = Chapter.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    return redirect_to admin_chapter_path(@chapter) if @chapter.update_attributes params[:chapter]
    redirect_to :action => :edit, :id => @chapter.id
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    @chapter.destroy
    redirect_to :action => :index
  end
end
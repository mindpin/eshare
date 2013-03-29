class AnnouncementsController < ApplicationController
  before_filter :pre_load

  def pre_load
    @announcement = Announcement.find(params[:id]) if params[:id]
  end


  def index
    @announcements = Announcement.all
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = current_user.announcements.build(params[:announcement])
    if @announcement.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def show
  end


end
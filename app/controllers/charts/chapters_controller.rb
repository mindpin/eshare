class Charts::ChaptersController < ApplicationController
  before_filter :authenticate_user!
  
  def read_pie
    @chapter = Chapter.find params[:id]
    render :json => @chapter.course_wares_read_stat_of(current_user)
  end
end
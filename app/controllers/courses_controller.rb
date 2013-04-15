class CoursesController < ApplicationController
  before_filter :pre_load

  def pre_load
    @course = Course.find(params[:id]) if params[:id]
  end

  def index
    @courses = Course.page(params[:page])
  end

  def show
    @chapters = @course.chapters.page(params[:page])
  end

  def manage
    @courses = current_user.courses.page(params[:page])
  end

  def manage_one
  end

  # 签到
  def sign
    @course.sign current_user
    render :json => {
      :streak => @course.current_streak_for(current_user),
      :order => @course.today_sign_order_of(current_user)
    }
  end
end
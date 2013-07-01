class UsersController < ApplicationController
  before_filter :authenticate_user!
  layout 'user_page'

  def me
    @user = current_user
    redirect_to "/users/#{@user.id}"
  end

  def show
    @user = User.find params[:id]
  end

  def courses
    @user = User.find params[:id]
    @courses = @user.learning_courses.page params[:page]
  end

  def questions
    @user = User.find params[:id]
    @questions = @user.questions.page params[:page]
  end

  def answers
    @user = User.find params[:id]
    @answers = @user.answers.page params[:page]
  end

  def course_applies
    @user = User.find params[:id]
    return render :text => '不能查看他人的选课记录', :status => 401 if @user != current_user
    @applies = @user.select_course_applies.page params[:page]
  end

  def complete_search
    query = params[:q]
    return render :json => [] if query.blank?

    result = Redis::Search.query 'User', query, :conditions => {:is_admin? => :false}
    result = Redis::Search.query 'User', query, :conditions => {:is_admin? => :false}
    # 这里需要查两遍，否则结果不准 BUG

    render :json => result
  end
end
class UsersController < ApplicationController
  layout 'user_page'

  def me
    @user = current_user
    render :show
  end

  def show
    @user = User.find params[:id]
  end

  def courses
    @user = User.find params[:id]
    @courses = @user.learning_courses.page(1).per(20)
  end

  def questions
    @user = User.find params[:id]
    @questions = @user.questions.page(1).per(20)
  end

  def answers
    @user = User.find params[:id]
    @answers = @user.answers.page(1).per(20)
  end
end
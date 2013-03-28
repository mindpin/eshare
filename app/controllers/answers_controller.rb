class AnswersController < ApplicationController
  before_filter :pre_load

  def pre_load
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = Answer.find(params[:id]) if params[:id]
  end

  def index
    @answers = @question.answers.page params[:page]
  end


  def create
    @answer = current_user.answers.build(params[:answer])
    @answer.question = @question
    if @answer.save
      return redirect_to "/questions/#{@answer.question_id}"
    end
    render 'questions/show'
  end

  def show
  end

  def edit
  end

  def update
    if @answer.update_attributes(params[:answer])
      return redirect_to "/questions/#{@answer.question_id}"
    end
    render :action => :edit
  end

end
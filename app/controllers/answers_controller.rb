class AnswersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :pre_load

  def pre_load
    @question = Question.find(params[:question_id]) if params[:question_id]
    @answer = Answer.find(params[:id]) if params[:id]
  end

  def create
    @answer = current_user.answers.build(params[:answer])
    @answer.question = @question
    if @answer.save
      return redirect_to "/questions/#{@answer.question_id}"
    end
    render 'questions/show'
  end

  def edit
  end

  def vote_up
    @answer.vote_up_by! current_user
    redirect_to :back
  end

  def vote_down
    @answer.vote_down_by! current_user
    redirect_to :back
  end

  def vote_cancel
    @answer.vote_cancel_by! current_user
    redirect_to :back
  end

  def update
    if request.xhr?
      if @answer.update_attributes(params[:answer])
        return render :json => {
          :status => 'ok', 
          :html => render_cell(:questions, :tree_answers, :user => current_user, :answers => [@answer])
        }
      end
      return render :text => 'question update error', :status => 500
    end

    if @answer.update_attributes(params[:answer])
      return redirect_to "/questions/#{@answer.question_id}"
    end
    render :action => :edit
  end

  def destroy
    @answer.destroy
    redirect_to :back
  end

end
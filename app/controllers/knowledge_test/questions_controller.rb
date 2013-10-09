class KnowledgeTest::QuestionsController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'flat-grid'
  end

  def index
    @questions = KnowledgeQuestion.page(params[:page]).per(10)
  end

  def show
    @question = KnowledgeQuestion.find(params[:id])
  end

  def submit_answer
    question = KnowledgeQuestion.find(params[:id])
    result = question.evaluate(params[:result])
    if result
      question.increase_correct_count_of_user(current_user)
    else
      question.increase_error_count_of_user(current_user)
    end

    render :json => {
      :result => result
    }
  end
end

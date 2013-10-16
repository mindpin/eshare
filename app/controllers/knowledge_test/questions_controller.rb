class KnowledgeTest::QuestionsController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'flat-grid'
  end

  def index
    @questions = KnowledgeQuestion.page(params[:page])
  end

  def show
    @question = KnowledgeQuestion.find(params[:id])
  end

  def submit_answer
    # TODO
  end
end
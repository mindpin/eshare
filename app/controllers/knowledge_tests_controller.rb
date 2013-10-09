class KnowledgeTestsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @nodes = KnowledgeNet::JAVASCRIPT_CORE.knowledge_nodes
  end

  def new
    question_id = params[:knowledge_question_id]
    return redirect_to :back if !question_id
    @question = KnowledgeQuestion.find(question_id)
    @record = KnowledgeAnswerRecord.new
    @record.knowledge_question_id = @question.id
  end

  def create
    question = KnowledgeQuestion.find(params[:question_id])
    result = question.evaluate(params[:answer])
    if result
      question.increase_correct_count_of_user(current_user)
    else
      question.increase_error_count_of_user(current_user)
    end
    redirect_to :action => :index
  end
end

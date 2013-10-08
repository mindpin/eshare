class KnowledgeQuestionsController < ApplicationController
  def index
    @questions = KnowledgeQuestion.all
  end

  def new
    @question = KnowledgeQuestion.new
    @question.kind = params[:kind]
  end

  def create
    puts params[:kind], params[:knowledge_question]
    question = KnowledgeQuestion.make(params[:kind], params[:knowledge_question])
    redirect_to :action => :index
  rescue Exception => ex
    redirect_to :back
  end
end

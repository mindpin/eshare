class KnowledgeQuestionsController < ApplicationController
  def index
    @questions = KnowledgeQuestion.all
  end

  def new
    @question = KnowledgeQuestion.new
    @question.kind = params[:kind]
  end

  def edit
    @question = KnowledgeQuestion.find(params[:id])
  end

  def update
    question = KnowledgeQuestion.find(params[:id])
    question.update_attributes(params[:knowledge_question], :as => question.kind)
    return redirect_to :action => :index if question.valid?
    redirect_to :back
  end

  def create
    puts params[:kind], params[:knowledge_question]
    question = KnowledgeQuestion.make(params[:kind], params[:knowledge_question])
    redirect_to :action => :index
  rescue Exception => ex
    redirect_to :back
  end
end

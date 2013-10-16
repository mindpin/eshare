class KnowledgeQuestionsController < ApplicationController
  def index
    @questions = KnowledgeQuestion.all
  end

  def new
    @nodes = get_knet.knowledge_nodes
    @question = KnowledgeQuestion.new
    @question.kind = params[:kind]
  end

  def edit
    @nodes = get_knet.knowledge_nodes
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
  end

  private

  def get_knet
    KnowledgeNet::JAVASCRIPT_CORE
  end
end

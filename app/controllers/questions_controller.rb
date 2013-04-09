class QuestionsController < ApplicationController
  before_filter :pre_load

  def pre_load
    @question = Question.find(params[:id]) if params[:id]
  end

  def index
    @feeds = Feed.on_scene(:questions).page params[:page]
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(params[:question])
    if @question.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def show
    @answer = Answer.new

    @question.visit_by!(current_user)
  end

  def edit
  end

  def update
    if @question.update_attributes(params[:question])
      return redirect_to :action => :index
    end
    render :action => :edit
  end

  def follow
    current_user.follow(@question)
    redirect_to :back
  end

  def unfollow
    current_user.unfollow(@question)
    redirect_to :back
  end

end
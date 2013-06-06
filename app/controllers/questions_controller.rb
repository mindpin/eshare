class QuestionsController < ApplicationController
  before_filter :pre_load
  layout Proc.new { |controller|
    case controller.action_name
    when 'show'
      return 'question_page'
    else
      return 'application'
    end
  }

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

    if request.xhr? && params[:course_ware_id]
      @course_ware = CourseWare.find params[:course_ware_id]
      @question.course_ware = @course_ware
      return render :text => (render_cell :questions, :list, :questions => [@question], :user => current_user) if @question.save
      return render :text => 'params invalid', :status => 500
    end
    
    return redirect_to @question if @question.save
    render :action => :new
  end

  def destroy
    @question = current_user.questions.find_by_id(params[:id])
    return render :text => 'access denied.', :status => 403 if @question.blank?

    if request.xhr?
      return render :text => 'delete ok' if @question.destroy
      return render :text => 'delete error', :status => 500
    end

    return redirect_to :action => :index if @question.destroy
    return redirect_to :action => :index
  end

  def show
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
    render :text => 'ok'
  end

  def unfollow
    current_user.unfollow(@question)
    render :text => 'ok'
  end

end
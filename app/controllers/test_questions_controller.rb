class TestQuestionsController < ApplicationController
  def index
    @test_questions = Course.find(params[:course_id]).test_questions
  end

  def show
    @test_question = TestQuestion.find(params[:id])
  end

  def create
    
    @course = Course.find(params[:course_id])
    @test_question = @course.test_questions.build(params[:test_question])

    return redirect_to :action => :show, :id => @test_question.id if @test_question.save
    redirect_to :action => :new
  end

  def new
    @test_question = TestQuestion.new
  end

  def edit
    @test_question = TestQuestion.find(params[:id])
  end

  def update
    @test_question = TestQuestion.find(params[:id])
    if @test_question.update_attributes params[:test_question]
      return redirect_to :action => :show, :id => @test_question.id
    end
    redirect_to :action => :edit, :id => @test_question.id
  end

  def destroy
    @test_question = TestQuestion.find(params[:id])
    @test_question.destroy
    redirect_to :action => :index, :course_id => @test_question.course_id
  end
end
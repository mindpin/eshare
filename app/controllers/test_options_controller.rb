class TestOptionsController < ApplicationController

  def index
    @test_options = Course.find(params[:course_id]).test_options
  end

  def new
    @test_option = TestOption.new
  end

  def create
    @course = Course.find(params[:course_id])
    @test_option = @course.test_options.build(params[:test_option])

    return redirect_to :action => :show, :id => @test_option.id if @test_option.save
    redirect_to :action => :new
  end

  def edit
    @test_option = TestOption.find(params[:id])
  end

  def update
    @test_option = TestOption.find(params[:id])
    return redirect_to :action => :show if @test_option.update_attributes params[:test_option]
    redirect_to :action => :edit, :id => @test_option.id
  end

  def show
    @test_option = TestOption.find(params[:id])
  end

  def destroy
    @test_option = TestOption.find(params[:id])
    @test_option.destroy
    redirect_to :action => :index, :course_id => @test_option.course_id
  end
end
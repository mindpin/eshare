class TestOptionController < ApplicationController
  before_filter :authenticate_user!

  def new
    @test_option = TestOption.new
  end

  def create
    @course = Course.find(params[:course_id])
    @test_option = TestOption.new(params[:test_option].merge(:course => @course))

    return redirect_to :action => :show, :id => @test_option.id if @test_option.save
    redirect_to :action => :new
  end

  def edit
    @test_option = Course.find(params[:course_id]).test_option
  end

  def update
    @test_option = Course.find(params[:course_id]).test_option
    return redirect_to :action => :show if @test_option.update_attributes params[:test_option]
    redirect_to :action => :edit, :id => @test_option.id
  end

  def show
    @test_option = Course.find(params[:course_id]).test_option
  end

  def destroy
    @test_option = Course.find(params[:course_id]).test_option
    @test_option.destroy
    redirect_to :action => :new, :course_id => @test_option.course_id
  end
end
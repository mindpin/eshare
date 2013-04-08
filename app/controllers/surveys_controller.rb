class SurveysController < ApplicationController
  def index
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    @survey.creator = current_user
    if @survey.save
      return redirect_to "/surveys"
    end
    render :action => :new
  end

  def show
    @survey = Survey.find(params[:id])
  end

  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy
    redirect_to '/surveys'
  end
end
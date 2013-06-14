class Manage::SurveysController < ApplicationController
  before_filter :authenticate_user!
  layout :get_layout
  def get_layout
    return 'manage'
  end

  def index
    @surveys = Survey.page(params[:page])
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new params[:survey]
    @survey.creator = current_user
    if @survey.save
      return redirect_to :action => :index
    end
    render :action => :new
  end

  def show
    @survey = Survey.find params[:id]
  end
end
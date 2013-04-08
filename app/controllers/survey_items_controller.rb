class SurveyItemsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_item = @survey.survey_items.build
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_item = @survey.survey_items.build(params[:survey_item])
    if @survey_item.save
      return redirect_to "/surveys/#{@survey.id}"
    end
    render :action => :new
  end
end
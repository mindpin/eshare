class SurveyResultsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_result = @survey.survey_results.build
  end

  def create
    @survey = Survey.find(params[:survey_id])
    survey_result = @survey.survey_results.build
    survey_result.survey_result_items_attributes = params[:survey_result_items_attributes]
    survey_result.creator = current_user
    if survey_result.save
      return redirect_to "/survey_results/#{survey_result.id}"
    end
    render :action => :new
  end

  def show
    @survey_result = SurveyResult.find(params[:id])
  end
end
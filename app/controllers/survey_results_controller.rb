class SurveyResultsController < ApplicationController
  def new
    @survey = Survey.find(params[:survey_id])
    @survey_result = @survey.survey_results.build
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey.record_result(current_user, params[:item])
    survey_result = @survey.survey_results.by_user(current_user).first
    redirect_to "/survey_results/#{survey_result.id}"
  end

  def show
    @survey_result = SurveyResult.find(params[:id])
  end
end
class Manage::SurveyResultsController < ApplicationController
  def show
    @survey_result = SurveyResult.find params[:id]
  end
end
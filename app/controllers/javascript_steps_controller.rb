class JavascriptStepsController < ApplicationController
  def first
    render :json => CourseWare.find(params[:course_ware_id]).javascript_steps.first.to_json
  end

  def next
    render :json => JavascriptStep.find(params[:id]).next.to_json
  end
end

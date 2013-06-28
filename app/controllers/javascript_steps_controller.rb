class JavascriptStepsController < ApplicationController
  before_filter :authenticate_user!

  def record_input
    input = params[:input]
    passed = params[:passed]

    step = JavascriptStep.find(params[:id])

    step.step_histories.create({
      :input => input,
      :is_passed => passed,
      :user => current_user  
    })

    render :text => 'ok'
  end
end

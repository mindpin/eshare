class HomeworkRequirementsController < ApplicationController
  def upload
    @requirement = HomeworkRequirement.find(params[:id])
    homework_upload = @requirement.homework_uploads.build(params[:homework_upload])
    homework_upload.creator = current_user
    homework_upload.save
    if request.xhr?
      render :text => 'ok'
      return
    end
    redirect_to "/homeworks/#{@requirement.homework_id}/student"
  end
end
class Admin::UserOpinionsController < ApplicationController
  layout 'admin'

  def index
    @user_opinions = UserOpinion.order('created_at DESC').page params[:page]
  end
end
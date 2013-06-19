class Help::UserOpinionsController < ApplicationController
  layout 'help'

  def new
    @user_opinion = UserOpinion.new
  end

  def create
    @user_opinion = UserOpinion.new params[:user_opinion]
    @user_opinion.user = current_user
    if @user_opinion.save
      redirect_to '/help/user_opinions/new?success=true'
      return
    end

    render :new
  end
end
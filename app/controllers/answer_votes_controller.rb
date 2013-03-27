class AnswerVotesController < ApplicationController
  before_filter :pre_load

  def pre_load
    @answer_vote = AnswerVote.find(params[:id]) if params[:id]
  end

  def vote_up
    @answer_vote.up

    redirect_to :back
  end

  def vote_down
    @answer_vote.down

    redirect_to :back
  end

  def destroy
    @answer_vote.destroy

    redirect_to :back
  end

end
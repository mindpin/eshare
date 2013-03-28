class AnswerVotesController < ApplicationController
  before_filter :pre_load

  def pre_load
    @answer = Answer.find(params[:answer_id]) if params[:answer_id]
  end

  def setup(kind)
    if @answer.has_voted_by?(current_user)
      return @answer.answer_votes.by_user(current_user).first
    end
    @answer.answer_votes.create(:creator => current_user, :kind => kind)
  end
  private :setup


  def up
    @answer_vote = setup('VOTE_UP')
    @answer_vote.up

    redirect_to :back
  end

  def down
    @answer_vote = setup('VOTE_DOWN')
    @answer_vote.down

    redirect_to :back
  end

  def cancel
    @answer.answer_votes.by_user(current_user).first.destroy

    redirect_to :back
  end

end
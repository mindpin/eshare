class AddVoteSumIntoAnswers < ActiveRecord::Migration
  def up
    add_column  :answers, :vote_sum, :integer
  end
end

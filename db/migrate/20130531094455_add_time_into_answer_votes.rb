class AddTimeIntoAnswerVotes < ActiveRecord::Migration
  def change
    add_column(:answer_votes, :created_at, :datetime, :null => false)
    add_column(:answer_votes, :updated_at, :datetime, :null => false)
  end
end

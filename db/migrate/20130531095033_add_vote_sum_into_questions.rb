class AddVoteSumIntoQuestions < ActiveRecord::Migration
  def change
    add_column(:questions, :vote_sum, :integer, :default => 0, :null => false)
  end
end

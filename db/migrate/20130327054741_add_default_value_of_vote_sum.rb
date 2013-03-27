class AddDefaultValueOfVoteSum < ActiveRecord::Migration
  def change
    change_column :answers, :vote_sum, :integer, :default => 0, :null => false
  end
end

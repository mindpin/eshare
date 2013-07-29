class AddRewardedColumnsOnQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :fine_answer_rewarded, :boolean 
    add_column :questions, :best_answer_rewarded, :boolean
  end
end

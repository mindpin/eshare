class AddRewardInQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :reward, :integer
  end
end

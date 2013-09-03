class AddAnswersCountIntoQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, :default => 0
  end
end
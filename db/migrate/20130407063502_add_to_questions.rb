class AddToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :chapter_id, :integer
    add_column :questions, :ask_to_user_id, :integer
  end

end

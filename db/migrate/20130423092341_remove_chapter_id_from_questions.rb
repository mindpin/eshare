class RemoveChapterIdFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :chapter_id
  end
end

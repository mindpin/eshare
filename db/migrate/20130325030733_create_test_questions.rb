class CreateTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_questions do |t| 
      t.string  :title
      t.integer :course_id
      t.integer :creator_id

      t.timestamps
    end
  end
end

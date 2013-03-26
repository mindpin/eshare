class CreateTestPaperTestQuestions < ActiveRecord::Migration
  def change
    create_table :test_paper_test_questions do |t|
      t.integer :test_paper_id
      t.integer :test_question_id

      t.timestamps
    end
  end
end

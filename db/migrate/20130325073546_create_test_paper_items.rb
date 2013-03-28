class CreateTestPaperItems < ActiveRecord::Migration
  def change
    create_table :test_paper_items do |t|
      t.integer :test_paper_id
      t.integer :test_question_id
      t.string  :answer_fill
      t.boolean :answer_true_false
      t.integer :answer_choice_mask

      t.timestamps
    end
  end
end

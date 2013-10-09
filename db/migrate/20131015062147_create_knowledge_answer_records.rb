class CreateKnowledgeAnswerRecords < ActiveRecord::Migration
  def change
    create_table :knowledge_answer_records do |t|
      t.integer :knowledge_question_id
      t.integer :user_id
      t.integer :correct_count # 答对次数
      t.integer :error_count   # 答错次数

      t.timestamps
    end
  end
end

class CreateKnowledgeQuestionFavs < ActiveRecord::Migration
  def change
    create_table :knowledge_question_favs do |t|
      t.integer :user_id
      t.integer :knowledge_question_id
      t.timestamps
    end
  end
end

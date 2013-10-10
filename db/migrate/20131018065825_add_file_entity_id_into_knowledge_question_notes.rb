class AddFileEntityIdIntoKnowledgeQuestionNotes < ActiveRecord::Migration
  def change
    remove_column :knowledge_question_notes, :image
    add_column :knowledge_question_notes, :file_entity_id, :integer
  end
end

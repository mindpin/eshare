class UpdateKnowledgeQuestionDiscussionModels < ActiveRecord::Migration
  def change
    remove_column :knowledge_question_posts, :image
    remove_column :knowledge_question_post_comments, :image
    add_column :knowledge_question_posts, :file_entity_id, :integer
    add_column :knowledge_question_post_comments, :file_entity_id, :integer
  end
end

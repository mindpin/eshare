class AddDefaultIntoKnowledgeAnswerRecords < ActiveRecord::Migration
  

  def change
    change_column_default(:knowledge_answer_records, :correct_count, 0)
    change_column_default(:knowledge_answer_records, :error_count, 0)
  end


end

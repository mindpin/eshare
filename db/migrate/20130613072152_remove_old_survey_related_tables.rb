class RemoveOldSurveyRelatedTables < ActiveRecord::Migration
  def up
    drop_table :survey_items
    drop_table :survey_result_items
    drop_table :survey_results
    drop_table :surveys
  end

  def down
  end
end

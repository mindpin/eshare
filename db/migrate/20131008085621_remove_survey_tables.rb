class RemoveSurveyTables < ActiveRecord::Migration
  def change
    drop_table :survey_result_items
    drop_table :survey_results
    drop_table :surveys
  end
end

class AddSurveyItemIdToSurveyResultItems < ActiveRecord::Migration
  def change
    add_column :survey_result_items, :survey_item_id, :integer
  end
end

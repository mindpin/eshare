class CreateSurveyResultItems < ActiveRecord::Migration
  def change
    create_table :survey_result_items do |t|
      t.integer :survey_result_id
      t.integer :answer_choice_mask
      t.string  :answer_fill
      t.text    :answer_text
      t.timestamps
    end
  end
end

class CreateSurveyItems < ActiveRecord::Migration
  def change
    create_table :survey_items do |t|
      t.integer :survey_id
      t.text    :content
      t.text    :choice_options
      t.string  :kind
      t.timestamps
    end
  end
end

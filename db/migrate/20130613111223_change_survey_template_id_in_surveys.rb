class ChangeSurveyTemplateIdInSurveys < ActiveRecord::Migration
  def up
    change_column :surveys, :survey_template_id, :string
  end

  def down
  end
end

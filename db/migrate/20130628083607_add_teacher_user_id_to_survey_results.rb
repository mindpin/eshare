class AddTeacherUserIdToSurveyResults < ActiveRecord::Migration
  def change
    add_column :survey_results, :teacher_user_id, :integer
  end
end

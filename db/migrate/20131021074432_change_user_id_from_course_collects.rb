class ChangeUserIdFromCourseCollects < ActiveRecord::Migration
  def change
    rename_column :course_collects, :user_id, :creator_id
  end
end

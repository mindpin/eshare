class AddSomeIndexToCourseTables < ActiveRecord::Migration
  def change
    add_index :chapters, :course_id
    add_index :course_wares, :chapter_id
    add_index :course_ware_readings, :course_ware_id
    add_index :course_ware_readings, :user_id
  end
end

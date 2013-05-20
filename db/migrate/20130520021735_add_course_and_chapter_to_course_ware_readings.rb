class AddCourseAndChapterToCourseWareReadings < ActiveRecord::Migration
  def change
    add_column :course_ware_readings, :chapter_id, :integer
    add_column :course_ware_readings, :course_id, :integer

    add_index :course_ware_readings, :chapter_id
    add_index :course_ware_readings, :course_id
  end
end

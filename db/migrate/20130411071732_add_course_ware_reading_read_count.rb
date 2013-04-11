class AddCourseWareReadingReadCount < ActiveRecord::Migration
  def change
    add_column :course_ware_readings, :read_count, :integer
  end
end

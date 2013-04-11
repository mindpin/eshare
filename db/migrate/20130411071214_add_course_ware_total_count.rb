class AddCourseWareTotalCount < ActiveRecord::Migration
  def change
    add_column :course_wares, :total_count, :integer
  end
end

class AddCourseSignStreak < ActiveRecord::Migration
  def change
    add_column :course_signs, :streak, :integer
  end
end

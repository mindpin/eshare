class AddDateToCourseSigns < ActiveRecord::Migration
  def change
    add_column :course_signs, :date, :integer
    add_index :course_signs, :date
  end
end

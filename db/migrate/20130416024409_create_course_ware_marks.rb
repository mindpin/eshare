class CreateCourseWareMarks < ActiveRecord::Migration
  def change
    create_table :course_ware_marks do |t|
      t.integer :user_id
      t.integer :course_ware_id
      t.integer :position
      t.text    :content

      t.timestamps
    end
  end
end

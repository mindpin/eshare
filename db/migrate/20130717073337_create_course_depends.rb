class CreateCourseDepends < ActiveRecord::Migration
  def change
    create_table :course_depends do |t|
      t.integer :before_course_id
      t.integer :after_course_id

      t.timestamps
    end
    
  end
end

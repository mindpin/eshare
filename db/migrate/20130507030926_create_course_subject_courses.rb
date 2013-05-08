class CreateCourseSubjectCourses < ActiveRecord::Migration
  def change
    create_table :course_subject_courses do |t|
      t.integer :course_subject_id
      t.integer :course_id
      
      t.timestamps
    end
  end
end

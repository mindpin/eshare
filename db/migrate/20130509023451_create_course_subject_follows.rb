class CreateCourseSubjectFollows < ActiveRecord::Migration
  def change
    create_table :course_subject_follows do |t|
      t.integer :course_subject_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end

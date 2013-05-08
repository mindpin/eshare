class CreateCourseSubjectManagerships < ActiveRecord::Migration
  def change
    create_table :course_subject_managerships do |t|
      t.integer :course_subject_id
      t.integer :user_id

      t.timestamps
    end

    add_column :course_subject_courses, :manager_id, :integer
  end
end

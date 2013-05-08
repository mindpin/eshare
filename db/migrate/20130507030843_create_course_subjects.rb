class CreateCourseSubjects < ActiveRecord::Migration
  def change
    create_table :course_subjects do |t|
      t.string  :title
      t.text    :desc
      t.integer :creator_id

      t.timestamps
    end
  end
end

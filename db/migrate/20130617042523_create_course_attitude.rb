class CreateCourseAttitude < ActiveRecord::Migration
  def change
    create_table :course_attitudes do |t|
      t.integer :user_id
      t.integer :course_id
      t.string  :kind
      t.string  :content
      t.timestamps
    end
  end
end

class CreateCourseSigns < ActiveRecord::Migration
  def change
    create_table :course_signs do |t|
      t.integer :course_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end

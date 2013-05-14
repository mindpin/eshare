class CreateSelectCourseApplies < ActiveRecord::Migration
  def change
    create_table :select_course_applies do |t|
      t.integer :course_id
      t.integer :user_id
      t.string  :status # 

      t.timestamps
    end
  end
end

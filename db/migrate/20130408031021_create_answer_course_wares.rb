class CreateAnswerCourseWares < ActiveRecord::Migration
  def change
    create_table :answer_course_wares do |t|
      t.integer :answer_id
      t.integer :course_ware_id
      t.timestamps
    end
  end
end

class CreateCourseInteractives < ActiveRecord::Migration
  def change
    create_table :course_interactives do |t|
      t.integer  :course_id
      t.integer  :date  # 取值类似这样 20130408
      t.integer  :sum  # 统计值
      t.timestamps
    end
  end
end

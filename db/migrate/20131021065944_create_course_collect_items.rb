class CreateCourseCollectItems < ActiveRecord::Migration
  def change
    create_table :course_collect_items do |t|
      t.integer :course_collect_id
      t.integer :course_id
      t.text    :comment

      t.timestamps
    end
  end
end

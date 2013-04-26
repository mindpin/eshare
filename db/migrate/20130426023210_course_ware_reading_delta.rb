class CourseWareReadingDelta < ActiveRecord::Migration
  def up
    create_table :course_ware_reading_delta do |t|
      t.integer :user_id
      t.integer :course_ware_id
      t.integer :date # like 20130426
      t.integer :change
      t.integer :value
    end

    add_index :course_ware_reading_delta, :user_id
    add_index :course_ware_reading_delta, :course_ware_id
    add_index :course_ware_reading_delta, :date
  end

  def down
  end
end

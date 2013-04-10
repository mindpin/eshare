class CreateCourseWareReadings < ActiveRecord::Migration
  def change
    create_table :course_ware_readings do |t|
      t.integer :user_id
      t.integer :course_ware_id
      t.boolean :read, :default => true
      
      t.timestamps
    end
  end
end

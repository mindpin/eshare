class AddSomeDateFieldToCourseWareReadingDelta < ActiveRecord::Migration
  def change
    add_column :course_ware_reading_delta, :year, :integer
    add_column :course_ware_reading_delta, :month, :integer
    add_column :course_ware_reading_delta, :day, :integer

    add_index :course_ware_reading_delta, :year
    add_index :course_ware_reading_delta, :month
    add_index :course_ware_reading_delta, :day
  end
end

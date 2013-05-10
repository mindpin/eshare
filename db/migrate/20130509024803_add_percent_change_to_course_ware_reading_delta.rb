class AddPercentChangeToCourseWareReadingDelta < ActiveRecord::Migration
  def change
    add_column :course_ware_reading_delta, :percent_change, :string, :default => '0%'
    add_column :course_ware_reading_delta, :percent_value, :string, :default => '0%'
    add_column :course_ware_reading_delta, :weekday, :integer
    add_column :course_ware_reading_delta, :total_count, :integer

    add_index :course_ware_reading_delta, :weekday
  end
end

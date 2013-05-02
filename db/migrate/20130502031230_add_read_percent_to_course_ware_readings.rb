class AddReadPercentToCourseWareReadings < ActiveRecord::Migration
  def change
    add_column :course_ware_readings, :read_percent, :string, :default => '0%'
  end
end

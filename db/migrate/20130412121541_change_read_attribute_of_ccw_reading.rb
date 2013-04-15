class ChangeReadAttributeOfCcwReading < ActiveRecord::Migration
  def change
    change_column :course_ware_readings, :read, :boolean, :default => false
  end
end

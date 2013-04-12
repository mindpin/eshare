class ChangeColumnsInHomeworkRecords < ActiveRecord::Migration
  def change
    add_column :homework_records, :status, :string
    remove_column :homework_records, :is_submitted
    remove_column :homework_records, :is_checked
  end
end

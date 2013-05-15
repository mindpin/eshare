class RemoveHomeworkRelatedTables < ActiveRecord::Migration
  def change
    drop_table :homework_attaches
    drop_table :homework_records
    drop_table :homework_requirements
    drop_table :homework_uploads
    drop_table :homeworks
  end
end

class RemovePracticeTables < ActiveRecord::Migration
  def change
    drop_table :practices
    drop_table :practice_attaches
    drop_table :practice_records
    drop_table :practice_requirements
    drop_table :practice_uploads
  end
end

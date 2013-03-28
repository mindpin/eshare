class CreateHomeworkRecords < ActiveRecord::Migration
  def change
    create_table :homework_records do |t|
      t.integer  :homework_id
      t.integer  :score

      t.boolean  :is_submitted
      t.datetime :submitted_at

      t.boolean  :is_checked
      t.datetime :checked_at

      t.integer  :creator_id

      t.timestamps
    end
  end
end

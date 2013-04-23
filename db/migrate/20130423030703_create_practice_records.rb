class CreatePracticeRecords < ActiveRecord::Migration
  def change
    create_table :practice_records do |t|
      t.integer  :practice_id
      t.integer  :user_id
      t.datetime :submitted_at
      t.datetime :checked_at
      t.string   :status

      t.timestamps
    end
  end
end

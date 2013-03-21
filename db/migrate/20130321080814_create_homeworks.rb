class CreateHomeworks < ActiveRecord::Migration
  def change
    create_table :homeworks do |t|
      t.string   :title
      t.text     :content
      t.integer  :chapter_id
      t.integer  :creator_id
      t.datetime :deadline
      t.timestamps
    end
  end
end

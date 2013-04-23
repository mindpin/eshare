class CreatePractice < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string   :title
      t.text     :content
      t.integer  :chapter_id
      t.integer  :creator_id

      t.timestamps
    end
  end
end

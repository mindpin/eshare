class CreatePracticeUploads < ActiveRecord::Migration
  def change
    create_table :practice_uploads do |t|
      t.integer  :requirement_id
      t.integer  :creator_id
      t.integer  :file_entity_id
      t.string   :name

      t.timestamps
    end
  end
end

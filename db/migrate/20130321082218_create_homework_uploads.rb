class CreateHomeworkUploads < ActiveRecord::Migration
  def change
    create_table :homework_uploads do |t|
      t.integer  :requirement_id
      t.integer  :file_entity_id
      t.string   :name
      t.integer  :creator_id
      t.timestamps
    end
  end
end

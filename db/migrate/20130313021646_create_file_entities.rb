class CreateFileEntities < ActiveRecord::Migration
  def change
    create_table :file_entities do |t|
      t.string   "attach_file_name"
      t.string   "attach_content_type"
      t.integer  "attach_file_size",    :limit => 8
      t.datetime "attach_updated_at"
      t.string   "md5"
      t.boolean  "merged",                           :default => false
      t.string   "video_encode_status"
      t.integer  "saved_size",          :limit => 8
      t.timestamps
    end
  end
end

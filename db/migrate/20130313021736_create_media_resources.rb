class CreateMediaResources < ActiveRecord::Migration
  def change
    create_table :media_resources do |t|
      t.integer  "file_entity_id"
      t.string   "name"
      t.boolean  "is_dir",         :default => false
      t.integer  "dir_id",         :default => 0
      t.integer  "creator_id"
      t.datetime "fileops_time"
      t.boolean  "is_removed",     :default => false
      t.integer  "files_count",    :default => 0
      t.boolean  "delta",          :default => true,  :null => false
      t.timestamps
    end
  end
end

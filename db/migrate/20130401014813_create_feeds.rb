class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.integer :user_id
      t.string  :scene

      t.integer :to_id
      t.string :to_type

      t.string :what
      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end

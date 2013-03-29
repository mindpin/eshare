class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.integer :creator_id
      t.integer :title
      t.string  :content
      
      t.timestamps
    end
  end
end

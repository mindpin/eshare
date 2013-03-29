class CreateAnnouncementUsers < ActiveRecord::Migration
  def change
    create_table :announcement_users do |t|
      t.integer :user_id
      t.integer :announcement_id
      t.boolean :read, :default => false, :null => false
      
      t.timestamps
    end
  end
end

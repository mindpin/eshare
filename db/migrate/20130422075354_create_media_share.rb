class CreateMediaShare < ActiveRecord::Migration
  def change
    create_table :media_shares do |t|
      t.integer :media_resource_id
      t.integer :receiver_id
      t.timestamps
    end
  end
end

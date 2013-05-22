class CreateOmniauths < ActiveRecord::Migration
  def change
    create_table :omniauths do |t|
      t.integer :user_id
      t.string :provider
      t.string :token
      t.string :expires_at
      t.boolean :expires
      t.timestamps
    end
  end
end

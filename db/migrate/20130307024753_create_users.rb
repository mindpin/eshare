class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :name,                      :default => "", :null => false
      t.string  :hashed_password,           :default => "", :null => false
      t.string  :salt,                      :default => "", :null => false
      t.string  :email,                     :default => "", :null => false
      t.string  :sign
      t.string  :activation_code
      t.string  :logo_file_name
      t.string  :logo_content_type
      t.integer :logo_file_size
      t.datetime :logo_updated_at
      t.datetime :activated_at
      t.string   :reset_password_code
      t.datetime :reset_password_code_until
      t.datetime :last_login_time
      t.boolean  :send_invite_email
      t.integer  :reputation,                :default => 0,  :null => false
      t.integer  :roles_mask
      t.timestamps
    end
  end
end

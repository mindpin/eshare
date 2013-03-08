class RemoveLogoFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :logo_file_name, :logo_content_type, :logo_file_size, :logo_updated_at
  end
end

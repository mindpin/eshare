class AddAvatarToTags < ActiveRecord::Migration
  def change
    add_column :tags, :avatar, :string
  end
end

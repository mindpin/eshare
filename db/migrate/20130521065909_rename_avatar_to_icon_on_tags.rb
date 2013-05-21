class RenameAvatarToIconOnTags < ActiveRecord::Migration
  def change
    rename_column :tags, :avatar, :icon
  end
end

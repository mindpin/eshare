class AddIsForcePublicToTaggings < ActiveRecord::Migration
  def change
    add_column :taggings, :is_force_public, :boolean
  end
end

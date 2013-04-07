class AddCategoryIdOnMediaResources < ActiveRecord::Migration
  def change
    add_column :media_resources, :category_id, :integer
  end
end

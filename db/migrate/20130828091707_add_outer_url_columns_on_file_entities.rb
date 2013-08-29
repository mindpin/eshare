class AddOuterUrlColumnsOnFileEntities < ActiveRecord::Migration
  def change
    add_column :file_entities, :outer_url, :text
    add_column :file_entities, :download_status, :string
  end
end

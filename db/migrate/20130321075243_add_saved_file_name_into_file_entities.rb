class AddSavedFileNameIntoFileEntities < ActiveRecord::Migration
  def change
    add_column :file_entities, :saved_file_name, :string
  end
end
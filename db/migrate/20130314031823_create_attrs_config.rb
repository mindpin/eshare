class CreateAttrsConfig < ActiveRecord::Migration
  def change
    create_table :attrs_configs do |t|
      t.string :role
      t.string :field
      t.string :field_type
      t.timestamps
    end
  end
end

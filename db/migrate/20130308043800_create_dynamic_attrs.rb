class CreateDynamicAttrs < ActiveRecord::Migration
  def change
    create_table :dynamic_attrs do |t|
      t.integer     :owner_id,    :null => false
      t.string      :owner_type,  :null => false
      t.string      :name,        :null => false
      t.string      :field,       :null => false
      t.string      :value
    end
    
    add_index :dynamic_attrs, [:owner_id, :owner_type]
    add_index :dynamic_attrs, [:name, :field]
  end
end

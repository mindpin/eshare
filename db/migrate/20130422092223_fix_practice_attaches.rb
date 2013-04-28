class FixPracticeAttaches < ActiveRecord::Migration
  def change
    drop_table :practice_attachs
    
    create_table :practice_attaches do |t|
      t.integer  :practice_id
      t.integer  :file_entity_id
      t.string   :name

      t.timestamps
    end
  end
end

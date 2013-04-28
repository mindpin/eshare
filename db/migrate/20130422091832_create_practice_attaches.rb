class CreatePracticeAttaches < ActiveRecord::Migration
  def change
    create_table :practice_attachs do |t|
      t.integer  :practice_id
      t.integer  :file_entity_id
      t.string   :name

      t.timestamps
    end
  end
end

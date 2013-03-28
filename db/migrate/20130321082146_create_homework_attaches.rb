class CreateHomeworkAttaches < ActiveRecord::Migration
  def change
    create_table :homework_attaches do |t|
      t.integer  :homework_id
      t.integer  :file_entity_id
      t.string   :name
      t.timestamps
    end
  end
end

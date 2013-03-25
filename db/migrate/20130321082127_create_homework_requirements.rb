class CreateHomeworkRequirements < ActiveRecord::Migration
  def change
    create_table :homework_requirements do |t|
      t.text   :content
      t.integer  :homework_id
      t.timestamps
    end
  end
end

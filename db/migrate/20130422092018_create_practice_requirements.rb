class CreatePracticeRequirements < ActiveRecord::Migration
  def change
    create_table :practice_requirements do |t|
      t.integer  :practice_id
      t.text     :content

      t.timestamps
    end
  end
end

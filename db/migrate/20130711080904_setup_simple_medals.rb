class SetupSimpleMedals < ActiveRecord::Migration
  def change
    create_table :user_medals do |t|
      t.integer :user_id
      t.string  :medal_name

      t.text    :data
      t.integer :model_id
      t.string  :model_type
      t.timestamps
    end
  end
end

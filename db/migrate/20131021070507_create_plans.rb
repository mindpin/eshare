class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :user_id
      t.string :knowledge_net_id
      t.integer :course_id
      t.integer :day_num
      t.timestamps
    end
  end
end

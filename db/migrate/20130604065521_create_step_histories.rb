class CreateStepHistories < ActiveRecord::Migration
  def change
    create_table :step_histories do |t|
      t.integer  :user_id
      t.integer :course_ware_id

      t.integer :step_id
      t.string  :step_type # 多态
      
      t.text    :input
      t.boolean :is_passed
      t.timestamps
    end
  end
end

class CreateQuestionFollows < ActiveRecord::Migration
  def change
    create_table :question_follows do |t|
      t.integer :user_id
      t.integer :question_id
      t.datetime :last_view_time
      
      t.timestamps
    end
  end
end

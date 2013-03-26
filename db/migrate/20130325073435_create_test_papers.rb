class CreateTestPapers < ActiveRecord::Migration
  def change
    create_table :test_papers do |t|
      t.integer :course_id
      t.integer :user_id

      t.timestamps
    end
  end
end

class CreateTestOptions < ActiveRecord::Migration
  def change
    create_table :test_options do |t|
      t.integer :course_id
      t.text    :rule
    end
  end
end

class CreateCourseCollects < ActiveRecord::Migration
  def change
    create_table :course_collects do |t|
      t.integer :user_id
      t.string :title
      t.text   :desc
      
      t.timestamps
    end
  end
end

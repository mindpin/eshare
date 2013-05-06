class CreateCourseFavs < ActiveRecord::Migration
  def change
    create_table :course_favs do |t|
      t.integer :course_id
      t.integer :user_id
      t.text    :comment_content

      t.timestamps
    end
  end
end

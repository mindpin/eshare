class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :desc
      t.integer :course_id
      t.integer :creator_id

      t.timestamps
    end
  end
end

class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :cid
      t.text :desc
      t.text :syllabus

      t.timestamps
    end
  end
end

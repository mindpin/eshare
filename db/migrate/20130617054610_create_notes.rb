class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text    :content
      t.string  :image
      t.boolean :is_private
      t.integer :course_ware_id
      t.integer :chapter_id   
      t.integer :course_id
      t.integer :creator_id
      
      t.timestamps
    end
  end
end

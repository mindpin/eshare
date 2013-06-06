class AddWithChapterToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :with_chapter, :boolean
  end
end

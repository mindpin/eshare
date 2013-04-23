class AddCoverUrlToCourseWare < ActiveRecord::Migration
  def change
    add_column :course_wares, :cover_url_cache, :string
  end
end

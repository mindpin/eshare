class AddUrlToCourseWare < ActiveRecord::Migration
  def change
    add_column :course_wares, :url, :string
  end
end

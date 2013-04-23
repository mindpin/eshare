class AddPositionToCourseWares < ActiveRecord::Migration
  def change
    add_column :course_wares, :position, :integer
  end
end

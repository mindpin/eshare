class ReAddMediaResourceIdToCourseWares < ActiveRecord::Migration
  def change
    add_column :course_wares, :media_resource_id, :integer
  end
end

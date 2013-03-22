class AddMediaResourceIdToCourseWares < ActiveRecord::Migration
  def change
    add_column :course_wares, :kind,              :string
    add_column :course_wares, :media_resource_id, :integer
  end
end

class ChangeMediaResourceIdToFileEntityIdOnCourseWares < ActiveRecord::Migration
  def change
    rename_column :course_wares, :media_resource_id, :file_entity_id
  end
end

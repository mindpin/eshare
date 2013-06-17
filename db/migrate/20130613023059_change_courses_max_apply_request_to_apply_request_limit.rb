class ChangeCoursesMaxApplyRequestToApplyRequestLimit < ActiveRecord::Migration
  def change
    rename_column :courses, :max_apply_request, :apply_request_limit
  end
end

class AddCourseMaxApplyRequest < ActiveRecord::Migration
  def change
    add_column :courses, :max_apply_request, :integer, :default => -1
  end
end

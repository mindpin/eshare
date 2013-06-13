class AddCourseMaxApplyRequest < ActiveRecord::Migration
  def change
    add_column :courses, :max_apply_request, :integer
  end
end

class ChangeDefaultValueOfCoursesStatus < ActiveRecord::Migration
  def change
    change_column_default :courses, :status, 'UNPUBLISHED'
  end
end

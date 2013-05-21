class RemoveDefaultValueOfLastViewTime < ActiveRecord::Migration
  def change
    change_column_default(:question_follows, :last_view_time, nil)
  end
end

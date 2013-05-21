class RemoveDefaultValueOfLastViewTime < ActiveRecord::Migration
  def change
    remove_column :question_follows, :last_view_time
    add_column :question_follows, :last_view_time, :datetime
  end
end

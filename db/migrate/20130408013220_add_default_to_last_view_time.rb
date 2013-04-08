class AddDefaultToLastViewTime < ActiveRecord::Migration
  def change
    change_column :question_follows, :last_view_time, :datetime, :default => Time.now
  end
end

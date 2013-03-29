class ChangeIntegerToStringFromAnnouncements < ActiveRecord::Migration
  def change
    change_column :announcements, :title, :string
  end
end

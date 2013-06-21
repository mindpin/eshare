class AddDataOnFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :data, :text
  end
end

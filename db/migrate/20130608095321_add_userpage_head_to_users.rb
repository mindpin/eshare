class AddUserpageHeadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :userpage_head, :string
  end
end

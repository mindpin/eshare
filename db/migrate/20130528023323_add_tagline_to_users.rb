class AddTaglineToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tagline, :text
  end
end

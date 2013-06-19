class AddUserIdToUserOpinions < ActiveRecord::Migration
  def change
    add_column :user_opinions, :user_id, :integer
    add_index :user_opinions, :user_id
  end
end

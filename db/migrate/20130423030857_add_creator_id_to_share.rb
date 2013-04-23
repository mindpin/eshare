class AddCreatorIdToShare < ActiveRecord::Migration
  def change
    add_column :media_shares, :creator_id, :integer
  end
end

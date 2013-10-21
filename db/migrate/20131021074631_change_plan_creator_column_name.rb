class ChangePlanCreatorColumnName < ActiveRecord::Migration
  def change
    remove_column :plans, :user_id
    add_column    :plans, :creator_id, :integer
  end
end

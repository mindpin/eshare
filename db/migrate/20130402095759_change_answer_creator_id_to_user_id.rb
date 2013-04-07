class ChangeAnswerCreatorIdToUserId < ActiveRecord::Migration
  def change
    rename_column :answer_votes, :creator_id, :user_id
  end
end

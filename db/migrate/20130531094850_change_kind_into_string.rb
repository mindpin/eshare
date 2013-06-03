class ChangeKindIntoString < ActiveRecord::Migration
  def change
    change_column(:answer_votes, :kind, :string)
  end
end

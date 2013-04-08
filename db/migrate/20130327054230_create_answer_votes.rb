class CreateAnswerVotes < ActiveRecord::Migration
  def change
    create_table :answer_votes do |t|
      t.integer  :creator_id
      t.integer  :answer_id
      t.text     :kind
    end
  end
end

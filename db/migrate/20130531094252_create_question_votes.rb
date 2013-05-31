class CreateQuestionVotes < ActiveRecord::Migration
  def chane

    create_table :question_votes do |t|
      t.integer :user_id
      t.integer :question_id
      t.string  :kind

      t.timestamps
    end

  end
end

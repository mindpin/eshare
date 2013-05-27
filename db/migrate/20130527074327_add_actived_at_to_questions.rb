class AddActivedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :actived_at, :datetime

    ActiveRecord::Base.record_timestamps = false
    Question.all.each do |q|
      q.actived_at = q.updated_at
      q.save
    end
  end
end

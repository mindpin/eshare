class AddActivedAtToQuestions < ActiveRecord::Migration
  def change
    
    add_column :questions, :actived_at, :datetime

    begin
      Question.record_timestamps = false
      Question.all.each do |q|
        q.actived_at = q.updated_at
        q.save
      end
    rescue
      p 'AddActivedAtToQuestions 数据无法被修改，但这不影响数据迁移'
    end

  end
end

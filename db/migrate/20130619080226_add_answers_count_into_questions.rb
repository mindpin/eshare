class AddAnswersCountIntoQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :answers_count, :integer, :default => 0

    Question.all.each do |question|
      question.without_feed do
        
          count = question.answers.count

          question.answers_count = count

          question.record_timestamps = false
          question.save
          question.record_timestamps = true

      end
    end
  end
end

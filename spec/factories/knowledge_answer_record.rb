FactoryGirl.define do
  factory :knowledge_answer_record do
    knowledge_question

    sequence(:correct_count){|n| n }
    sequence(:error_count){|n| n }

    user
  end
end
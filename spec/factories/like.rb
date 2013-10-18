FactoryGirl.define do
  factory :like do
    model {create :knowledge_question_post}
    user
  end
end

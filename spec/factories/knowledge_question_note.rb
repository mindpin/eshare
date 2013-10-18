FactoryGirl.define do
  factory :knowledge_question_note do
    knowledge_question

    # sequence(:content){|n| "content_#{n}" }

    creator
  end
end
FactoryGirl.define do
  factory :knowledge_question_post_comment, :aliases => [:main_comment] do
    creator
    knowledge_question_post

    content   "xxxx"
    file_entity
    code      "var x = 1"
    code_type "blascript"

    trait :reply do
      reply_comment {create :knowledge_question_post_comment}
    end
  end
end

FactoryGirl.define do
  factory :knowledge_question_post do
    knowledge_question

    content   "xxxx"
    file_entity
    code      "var x = 1"
    code_type "blascript"
    creator
  end
end

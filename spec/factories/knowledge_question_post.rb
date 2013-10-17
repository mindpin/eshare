FactoryGirl.define do
  factory :knowledge_question_post do
    knowledge_question

    content   "xxxx"
    image     "http://xxx/x.jpg"
    code      "var x = 1"
    code_type "blascript"
    creator
  end
end

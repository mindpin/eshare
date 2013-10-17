FactoryGirl.define do
  factory :knowledge_question_note do
    knowledge_question

    # sequence(:content){|n| "content_#{n}" }
    # sequence(:image){|n| "image_#{n}" }
    # sequence(:code){|n| "code_#{n}" }
    
    sequence(:code_type){|n| "code_type_#{n}" }

    creator
  end
end
FactoryGirl.define do
  factory :question do
    sequence(:title){|n| "question_title_#{n}" }
    sequence(:content){|n| "content_#{n}" }
    is_anonymous false
    creator
  end
end
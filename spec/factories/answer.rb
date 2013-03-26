FactoryGirl.define do
  factory :answer do
    question
    sequence(:content){|n| "content_#{n}" }
    creator
  end
end
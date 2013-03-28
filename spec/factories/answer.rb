FactoryGirl.define do
  factory :answer do
    sequence(:id){|n| "#{n}" }
    question
    sequence(:content){|n| "content_#{n}" }
    creator
  end
end
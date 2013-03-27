FactoryGirl.define do
  factory :answer do
    question
    sequence(:content){|n| "content_#{n}" }
    sequence(:vote_sum){|n| "#{n}" }
    creator
  end
end
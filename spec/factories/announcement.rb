FactoryGirl.define do
  factory :announcement do
    sequence(:id){|n| "#{n}" }
    sequence(:title){|n| "title_#{n}" }
    sequence(:content){|n| "content_#{n}" }
    creator
  end
end
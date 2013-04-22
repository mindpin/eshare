FactoryGirl.define do
  factory :practice do
    sequence(:title){|n| "title_#{n}" }
    sequence(:content){|n| "content_#{n}" }
    chapter
    creator
  end
end
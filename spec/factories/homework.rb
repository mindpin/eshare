FactoryGirl.define do
  factory :homework do
    sequence(:title){|n| "title_#{n}" }
    chapter
    creator
  end
end
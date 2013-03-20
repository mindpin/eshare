FactoryGirl.define do
  factory :chapter do
    sequence(:title){|n| "title_#{n}" }
    course
    creator
  end
end
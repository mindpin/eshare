FactoryGirl.define do
  factory :test_question do
    sequence(:title){|n| "title_#{n}"}

    course
    creator
  end
end
FactoryGirl.define do
  factory :test_question do
    sequence(:title){|n| "title_#{n}"}
    course
    creator
    kind {TestQuestion::KINDS.keys[3]}
  end
end
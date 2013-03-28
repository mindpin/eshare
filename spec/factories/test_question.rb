FactoryGirl.define do
  factory :test_question do
    sequence(:title){|n| "title_#{n}"}
    course
    creator
    kind {TestQuestion::KINDS.keys[rand 4]}

    TestQuestion::KINDS.keys.each do |kind|
      trait kind.downcase.to_sym do
        kind kind
      end
    end
  end
end
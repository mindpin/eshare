FactoryGirl.define do
  factory :test_question do
    sequence(:title){|n| "title_#{n}"}
    course
    creator
    test_question_choice_options({'A' => '1', 'B' => '2', 'C' => '3', 'D' => '4', 'E' => '5'})
    kind {TestQuestion::KINDS.keys[rand 4]}
  end
end
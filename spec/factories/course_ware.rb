FactoryGirl.define do
  factory :course_ware do
    sequence(:title){|n| "title_#{n}" }
    sequence(:desc){|n| "desc_#{n}"}
    chapter
    creator
  end
end
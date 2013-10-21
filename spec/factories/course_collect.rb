FactoryGirl.define do

  factory :course_collect do
    sequence(:title){|n| "title_#{n}" }
    sequence(:desc){|n| "desc_#{n}" }

    creator
  end
end
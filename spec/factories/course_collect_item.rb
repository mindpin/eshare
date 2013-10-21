FactoryGirl.define do

  factory :course_collect_item do
    sequence(:comment){|n| "comment_#{n}" }

    course
    course_collect
  end
end
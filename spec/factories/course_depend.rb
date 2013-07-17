FactoryGirl.define do
  factory :course_depend do
    sequence(:before_course_id){|n| "#{n}" }
    sequence(:after_course_id){|n| "#{n}" }
  end
end
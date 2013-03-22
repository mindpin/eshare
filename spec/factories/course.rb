FactoryGirl.define do
  factory :course do
    sequence(:name){|n| "course_name_#{n}" }
    sequence(:cid){|n| n }
    sequence(:desc){|n| "desc_#{n}" }
    sequence(:syllabus){|n| "syllabus_#{n}" }

    creator
  end
end
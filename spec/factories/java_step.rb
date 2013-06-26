FactoryGirl.define do
  factory :java_step do
    course_ware

    sequence(:title){|n| "title_#{n}" }
    sequence(:desc){|n| "desc_#{n}" }
    sequence(:hint){|n| "hint_#{n}" }
    sequence(:content){|n| "content_#{n}" }
    sequence(:rule){|n| "rule_#{n}" }
    sequence(:init_code){|n| "init_code_#{n}" }
  end
end
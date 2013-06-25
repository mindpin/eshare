FactoryGirl.define do
  factory :sql_step do
    course_ware
    title(:title){|n| "title_#{n}" }
    desc(:desc){|n| "desc_#{n}" }
    desc(:hint){|n| "hint_#{n}" }
    desc(:content){|n| "content_#{n}" }
    desc(:rule){|n| "rule_#{n}" }
    desc(:init_code){|n| "init_code_#{n}" }
  end
end
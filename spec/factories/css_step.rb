FactoryGirl.define do

  factory :css_step do
    course_ware
    
    sequence(:content){|n| "content_#{n}" }
    sequence(:rule){|n| "rule_#{n}" }
  end

end
FactoryGirl.define do

  factory :environment_config_state do
    course_ware
    
    sequence(:content){|n| "content_#{n}" }
    sequence(:title){|n| "title_#{n}" }
  end

end
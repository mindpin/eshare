FactoryGirl.define do
  factory :activity do
    sequence(:title)  {|n| "title_#{n}"   }
    sequence(:content){|n| "content_#{n}" }
    creator
    sequence(:start_time){ Time.now + 2.day }
    sequence(:end_time)  { Time.now + 4.day }
  end
end
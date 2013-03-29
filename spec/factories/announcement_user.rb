FactoryGirl.define do
  factory :announcement_user do
    sequence(:id){|n| "#{n}" }

    announcement
    creator

    read true
  end
end
FactoryGirl.define do
  factory :announcement_user do
    sequence(:id){|n| "#{n}" }

    announcement
    user

    read true
  end
end
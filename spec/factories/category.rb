FactoryGirl.define do
  factory :category do
    sequence(:name){|n| "name_#{n}" }
  end
end
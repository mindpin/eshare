FactoryGirl.define do
  factory :tag do
    sequence(:name) {|n| "name_#{n}"}
  end
end
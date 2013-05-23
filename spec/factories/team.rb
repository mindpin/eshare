FactoryGirl.define do
  factory :team do
    sequence(:name) {|n| "name_n"}

    creator
  end
end
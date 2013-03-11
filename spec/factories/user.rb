FactoryGirl.define do
  sequence(:num) {|n| n}

  factory :user do
    login    {"user#{generate(:num)}"}
    name     {"用户#{generate(:num)}"}
    email    {"user#{generate(:num)}@edu.dev"}
    password '1234'
  end
end

FactoryGirl.define do
  factory :attrs_config do
    role       :student
    field      {"field#{generate(:num)}"}
    field_type :string
  end
end

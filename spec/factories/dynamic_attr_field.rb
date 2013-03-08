FactoryGirl.define do
  factory :dynamic_attr do
    owner
    owner_type 'User'
    name       'test_attrs'
    field      'test_field'
    value      'test_value'
  end
end

FactoryGirl.define do
  factory :attrs_config do
    name   :test_attrs
    config({:string_field => :string, :boolean_field => :boolean})
  end
end

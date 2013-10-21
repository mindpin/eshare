FactoryGirl.define do
  factory :plan do
    creator
    knowledge_net_id "n04"
    course
    day_num {rand 16}
  end
end

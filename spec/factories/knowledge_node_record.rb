FactoryGirl.define do
  factory :knowledge_node_record do

    sequence(:knowledge_node_id){|n| "node_#{n}" }
    sequence(:knowledge_net_id){|n| "net_#{n}" }

  end
end
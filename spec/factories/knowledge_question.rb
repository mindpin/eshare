FactoryGirl.define do
  factory :knowledge_question do
    sequence(:knowledge_node_id)  {|n| "knowledge_node_id_#{n}"   }
    sequence(:kind){|n| "kind_#{n}" }
    sequence(:title){|n| "title_#{n}" }
    sequence(:desc){|n| "desc_#{n}" }
    sequence(:rule){|n| "rule_#{n}" }
    sequence(:init_code){|n| "init_code_#{n}" }
    sequence(:code_type){|n| "code_type_#{n}" }
    sequence(:choices){|n| "choices_#{n}" }
    sequence(:answer){|n| "answer_#{n}" }
    
  end
end
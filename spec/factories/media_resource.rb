FactoryGirl.define do
  factory :media_resource do
    sequence(:name){|n|"name_#{n}"}
    dir_id 0
    creator
    fileops_time Time.now
    is_removed false
    files_count 0
    delta true

    trait :file do
      is_dir false
      file_entity
    end

    trait :dir do
      is_dir true
    end
  end

end
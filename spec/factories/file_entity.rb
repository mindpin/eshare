FactoryGirl.define do
  factory :file_entity do
    sequence(:attach_file_name){|n| "origin_#{n}.jpg"}
    attach_content_type 'image/jepg'
    attach_file_size 100
    saved_size 100
    merged true
  end
end
FactoryGirl.define do
  factory :file_entity do
    attach File.open(File.expand_path(File.dirname(__FILE__) +'/../support/resources/test.ppt'))
  end
end

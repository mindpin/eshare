FactoryGirl.define do
  factory :chapter do
    title '测试章节1'
    desc '介绍'
    creator {FactoryGirl.create :user, :teacher}
  end
end

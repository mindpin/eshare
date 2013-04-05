FactoryGirl.define do
  factory :survey do
    sequence(:title) {|n| "title_n"}
    sequence(:content) {|n| "content_n"}

    creator
  end
end
FactoryGirl.define do
  factory :feed, :class => MindpinFeeds::Feed do
    who   {FactoryGirl.create :user}
    scene {:foo}
    to    {FactoryGirl.create :question}
    what  {"#{%w(update create)[rand 2]}_question"}
  end
end

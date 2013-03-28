FactoryGirl.define do
  factory :answer_vote do
    answer
    kind "VOTE_UP"
    creator
  end
end
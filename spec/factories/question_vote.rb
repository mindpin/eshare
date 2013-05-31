FactoryGirl.define do
  factory :question_vote do
    question
    kind 'VOTE_UP'
    user
  end
end
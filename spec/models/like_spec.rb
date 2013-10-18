require "spec_helper"

describe Like do
  let(:like)  {FactoryGirl.create :like}
  let(:user)  {like.user}
  let(:model) {like.model}
  let(:query) {user.likes.with_model(model)}
  let(:like2) {FactoryGirl.create :like, :user => user, :model => model}
  
  specify {
    expect {like2}.to raise_error {ActiveRecord::RecordInvalid}
    query.size.should be 1
  }

  describe Like::UserMethods do
    let(:user2)  {FactoryGirl.create :user}
    let(:query2) {user2.likes.with_model(model)}

    describe "#like" do
      specify {
        expect {user2.like(model)}.to change {query2.size}.by(1)
      }
    end

    describe "#cancel_like" do
      before {user2.like(model)}

      specify {
        expect {user2.cancel_like(model)}.to change {query2.size}.by(-1)
      }
    end
  end
end

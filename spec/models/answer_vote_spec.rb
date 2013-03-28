require "spec_helper"

describe AnswerVote do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create(:user)

      @answer = FactoryGirl.create(:answer)
    }

    

    it "投赞成票" do
      @vote = AnswerVote.create(:answer_id => @answer.id, 
        :kind => 'VOTE_DOWN', 
        :creator_id => @user.id
      )

      @vote.up
      @vote.kind.should == "VOTE_UP"

    end

    it "投反对票" do
      @vote = AnswerVote.create(:answer_id => @answer.id, 
        :kind => 'VOTE_UP', 
        :creator_id => @user.id
      )
      @vote.down
      @vote.kind.should == "VOTE_DOWN"
    end


  end
end
require "spec_helper"

describe AnswerVote do
  describe 'Validation' do
    before {
      5.times { FactoryGirl.create(:user) }
      @users = User.all

      @answer = FactoryGirl.create(:answer)

      AnswerVote.create(:answer_id => @answer.id, :kind => 'VOTE_UP', :creator_id => @users[2].id)
      AnswerVote.create(:answer_id => @answer.id, :kind => 'VOTE_UP', :creator_id => @users[3].id)
      AnswerVote.create(:answer_id => @answer.id, :kind => 'VOTE_UP', :creator_id => @users[4].id)
    }


    it "投赞成票" do
      @answer_vote_down = AnswerVote.create(:answer_id => @answer.id, 
        :kind => 'VOTE_DOWN', 
        :creator_id => @users[0].id
      )
      @answer_vote_down.up
      @answer_vote_down.kind.should == "VOTE_UP"

    end

    it "投反对票" do
      @answer_vote_up = AnswerVote.create(:answer_id => @answer.id, 
        :kind => 'VOTE_UP', 
        :creator_id => @users[1].id
      )
      @answer_vote_up.down
      @answer_vote_up.kind.should == "VOTE_DOWN"
    end


  end
end
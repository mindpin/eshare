require "spec_helper"

describe AnswerVote do
  describe 'Validation' do
    before {
      5.times { FactoryGirl.create(:user) }
      @users = User.all

      @answer = FactoryGirl.create(:answer)

      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[2])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[3])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[4])
    }


    it "投赞成票" do
      @answer_vote_up = AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[0])
      @answer_vote_down.up
      @answer_vote_down.kind.should == "VOTE_UP"

    end

    it "投反对票" do
      @answer_vote_down = AnswerVote.create(:answer => @answer, :kind => 'VOTE_DOWN', :creator => @users[1])
      @answer_vote_up.down
      @answer_vote_up.kind.should == "VOTE_DOWN"
    end


  end
end
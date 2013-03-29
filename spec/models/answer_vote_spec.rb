require "spec_helper"

describe AnswerVote do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create(:user)

      @answer = FactoryGirl.create(:answer)
      @vote = AnswerVote.new(:answer => @answer, :creator => @user)
    }

    

    it "投赞成票" do
      @vote.kind = 'VOTE_DOWN'
      @vote.save
      
      @vote.up
      @vote.kind.should == "VOTE_UP"

    end

    it "投反对票" do
      @vote.kind = 'VOTE_UP'
      @vote.save

      @vote.down
      @vote.kind.should == "VOTE_DOWN"
    end


  end
end
require "spec_helper"

describe Answer do
  describe 'Validation' do
    before {
      5.times { FactoryGirl.create(:user) }
      @users = User.all

      @answer = FactoryGirl.create(:answer)
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[0])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_DOWN', :creator => @users[1])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[2])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[3])
      AnswerVote.create(:answer => @answer, :kind => 'VOTE_UP', :creator => @users[4])
    }


    it "验证当前答案投票总和" do
      @answer.vote_sum.should == 3
    end


  end
end
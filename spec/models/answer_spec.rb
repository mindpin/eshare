require "spec_helper"

describe Answer do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create(:user, id: 1000)

      @answer = FactoryGirl.create(:answer, id: 200, vote_sum: 0)
      @sum = @answer.vote_sum
      @vote = AnswerVote.new(:creator => @user, :answer => @answer)

      @answer_voted = FactoryGirl.create(:answer, id: 300, vote_sum: 0)
      @vote_for_answer = FactoryGirl.create(:answer_vote, 
        :creator => @user, 
        :kind => 'VOTE_UP', 
        :answer => @answer_voted
      )
      @answer_vote = @answer_voted.answer_votes.by_user(@user).first
    }

    it "没有投过票" do
      answer_without_vote = FactoryGirl.create(:answer)
      answer_without_vote.has_voted_by?(@user).should == false
    end

    it "已经投过票" do
      @answer_voted.has_voted_by?(@user).should == true
    end


    it "用户的投票记录" do
      @answer_vote.kind.should == 'VOTE_UP'
      @answer_vote.answer.id.should == 300
      @answer_vote.creator.id.should == 1000
    end

    
    it "总分数要加1" do
      @vote.kind = 'VOTE_UP'
      @vote.save

      (@answer.vote_sum - @sum).should == 1
    end

    it "总分数要减1" do
      @vote.kind = 'VOTE_DOWN'
      @vote.save

      (@answer.vote_sum - @sum).should == -1
    end


    it "up方法, 总分数要加1" do
      @vote.up

      (@answer.vote_sum - @sum).should == 1
    end

    it "down方法, 总分数要减1" do
      @vote.down

      (@answer.vote_sum - @sum).should == -1
    end

  end
end
require "spec_helper"

describe Answer do
  describe 'Validation' do
    before {
      3.times { FactoryGirl.create(:user) }
      @users = User.all

      @answer = FactoryGirl.create(:answer)

      @vote1 = AnswerVote.create(:creator_id => @users[0].id,
        :answer_id => @answer.id,
        :kind => 'VOTE_UP'
      )
      @sum1 = @answer.vote_sum

      @vote2 = AnswerVote.create(:creator_id => @users[1].id,
        :answer_id => @answer.id,
        :kind => 'VOTE_UP'
      )
      @sum2 = @answer.vote_sum

      @vote3 = AnswerVote.create(:creator_id => @users[2].id,
        :answer_id => @answer.id,
        :kind => 'VOTE_DOWN'
      )
      @sum3 = @answer.vote_sum
    }



    it "投票总分数" do
      @answer.vote_sum.should == 1
    end


    it "按照投票分数排序" do
      @sum1.should be < @sum2
      @sum2.should be > @sum3
      @sum1.should be = @sum3
    end


  end
end
require "spec_helper"

describe Question do
  describe '不能为空较验' do
    before {
      3.times { FactoryGirl.create(:question) }
      @questions = Question.all
    }

    it "should order by id desc" do
      @questions.last.id.should be < @questions.first.id
    end
  end

  context '#answered_by?' do
    before {
      @question     = FactoryGirl.create :question
      @user         = FactoryGirl.create :user
      @another_user = FactoryGirl.create :user
      @answer       = FactoryGirl.create :answer, :question => @question,
                                                  :creator => @user
    }

    it {
      @question.answered_by?(@user).should == true
    }

    it {
      @question.answered_by?(@another_user).should == false
    }

    it {
      @question.answer_of(@user).should == Answer.last
    }
  end
end

describe Answer do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create :user
      @answer = FactoryGirl.create :answer
    }

    it {
      @answer.vote_sum.should == 0
    }

    it "没有投过票" do
      @answer.has_voted_by?(@user).should == false
    end

    it "已经投过票" do
      @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                               :answer => @answer
      @answer.has_voted_by?(@user).should == true
    end

    it "用户的投票记录" do
      @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                               :answer => @answer,
                                               :kind => 'VOTE_UP'
      @vote.kind.should == 'VOTE_UP'
      @vote.answer.should == @answer
      @vote.user.should == @user
    end

    context '赞成票' do
      it do
        expect {
          @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                                   :answer => @answer,
                                                   :kind => 'VOTE_UP'
        }.to change {
          @answer.vote_sum
        }.by(1)
      end

      it {
        @answer.vote_up_by!(@user)
        @answer.vote_down_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }

      it {
        expect {
          @answer.vote_up_by!(@user)
        }.to change {
          @answer.vote_sum
        }.by(1)
      }

      it {
        @answer.vote_up_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }
    end
    
    context '反对票' do
      it do
        expect {
          @vote = FactoryGirl.create :answer_vote, :user => @user, 
                                                   :answer => @answer,
                                                   :kind => 'VOTE_DOWN'
        }.to change {
          @answer.vote_sum
        }.by(-1)
      end

      it {
        expect {
          @answer.vote_down_by!(@user)
        }.to change {
          @answer.vote_sum
        }.by(-1)
      }

      it {
        @answer.vote_down_by!(@user)
        @answer.answer_votes.by_user(@user).count.should == 1
      }
    end

    context '被不同人反复投票' do
      before {
        @user_a = FactoryGirl.create(:user)
        @user_b = FactoryGirl.create(:user)
      }

      it {
        expect {
          @answer.vote_down_by! @user 

          @answer.vote_down_by! @user_a
          @answer.vote_down_by! @user_a

          @answer.vote_down_by! @user_b
          @answer.vote_up_by! @user_b

          @answer.vote_up_by! @user

          @answer.vote_up_by! FactoryGirl.create(:user)

          # 最终结果
          # @user +1
          # @user_a -1
          # @user_b +1
          # another_user +1
        }.to change {
          @answer.vote_sum
        }.by(+1-1+1+1)
      }
    end

    context '取消投票' do
      it {
        expect {
          @answer.vote_down_by! @user 
          @answer.vote_cancel_by! @user
        }.to change {
          @answer.vote_sum
        }.by(0)
      }
    end
  end
end

describe AnswerVote do
  context('Validation') {
    before {
      @question     = FactoryGirl.create :question
      @user         = FactoryGirl.create :user
      @answer       = FactoryGirl.create :answer, :question => @question,
                                                  :creator => @user
    }

    it {
      vote = AnswerVote.new :answer => @answer,
                            :user => @user
      vote.valid?.should == false
    }

    context {
      before { @vote = @answer.answer_votes.create :user => @user }
      it { @vote.valid?.should == false }
      it { AnswerVote.count.should == 0 }
    }

    context {
      before {
        @vote = @answer.answer_votes.create :user => @user
        @vote.update_attribute :kind, 'VOTE_CANCEL'
      }
      it { @vote.valid?.should == true }
      it { AnswerVote.count.should == 1 }
    }

    context {
      before {
        @vote = @answer.answer_votes.create :user => @user
        @vote.update_attributes :kind => 'XXXX'
        # udpate_attribute 方法不会触发校验
      }
      it { @vote.valid?.should == false }
      it { AnswerVote.count.should == 0 }
    }
  }
end
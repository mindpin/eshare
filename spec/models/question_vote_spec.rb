require "spec_helper"

describe QuestionVote do
  describe('Validation') {
    before {
      @question_user         = FactoryGirl.create :user
      @vote_user         = FactoryGirl.create :user
      @question     = FactoryGirl.create :question, :creator => @question_user
    }

    describe "new 直接创建" do
      before { 
        @vote = QuestionVote.new :question => @question, :user => @vote_user
      }

      it "无效的投票记录" do
        @vote.valid?.should == false 
      end

      it "数量为0" do
       QuestionVote.count.should == 0
      end
    end

    describe "create 直接创建" do
      before { 
        @vote = @question.question_votes.create :user => @vote_user 
      }

      it "无效的投票记录" do
        @vote.valid?.should == false 
      end

      it "数量为0" do
       QuestionVote.count.should == 0
      end

    end

    describe "create 先创建, 再 update kind 字段" do
      before {
        @vote = @question.question_votes.create :user => @vote_user
        @vote.update_attribute :kind, 'VOTE_CANCEL'
      }

      it "有效的投票记录" do
        @vote.valid?.should == true 
      end

      it "数量为1" do
        QuestionVote.count.should == 1 
      end
    }

    describe "不能对自己的创建的问题进行投票(1)" do

      before {
        @vote = @question.question_votes.create :user => @question_user
        @vote.kind = 'VOTE_UP'
        @vote.save
      }

      it "无效的投票记录" do
        @vote.valid?.should == false 
      end

      it "数量为0" do
       QuestionVote.count.should == 0
      end

      it "vote_up_by! 无记录" do
        @question.vote_up_by! @question_user

        QuestionVote.count.should == 0
      end

      it "vote_down_by! 无记录" do
        @question.vote_down_by! @question_user

        QuestionVote.count.should == 0
      end

      it "vote_cancel_by! 无记录" do
        @question.vote_cancel_by! @question_user

        QuestionVote.count.should == 0
      end
      
    end

    describe "使用不正确的 kind 值" do
      before {
        @vote = @question.question_votes.create :user => @vote_user
        @vote.update_attributes :kind => 'XXXX'
      }

      it "无效的投票记录" do
        @vote.valid?.should == false 
      end

      it "数量为0" do
       QuestionVote.count.should == 0
      end

    end
  }

  describe '问题投票的级联删除' do
    before {
      @question = FactoryGirl.create :question
      5.times do
        vote = FactoryGirl.create :question_vote, :question => @question
      end
    }

    it "question 数量为1" do
      Question.count.should == 1
    end

    it "question_votes 数量为5" do
      @question.question_votes.count.should == 5
    end

    it "删除问题，问题数为 0" do
      @question.destroy
      Question.count.should == 0
    end

    it "删除问题，投票数为 0" do
      @question.destroy
      QuestionVote.count.should == 0
    end
  end
end
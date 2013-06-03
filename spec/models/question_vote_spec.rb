require "spec_helper"

describe QuestionVote do
  describe('Validation') {
    before {
      @question_user         = FactoryGirl.create :user
      @vote_user         = FactoryGirl.create :user

      Timecop.travel(Time.now - 2.day) do
        @question     = FactoryGirl.create :question, :creator => @question_user
      end

      @updated_at = @question.updated_at
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
        @vote = @question.question_votes.create :user => @vote_user, :kind => 'VOTE_UP'
        @question.reload
      }

      it "有效的投票记录" do
        @vote.valid?.should == true 
      end

      it "数量为1" do
        QuestionVote.count.should == 1 
      end

      it "vote_sum in question 记录为 1" do
        @question.vote_sum.should == 1
      end

      it "问题投票, updated_at 不更新" do
        @question.updated_at.to_i.should == @updated_at.to_i
      end

      describe "更新 kind 状态" do
        before {
          @vote.update_attribute :kind, 'VOTE_DOWN'
        }

        it "有效的投票记录" do
          @vote.valid?.should == true 
        end

        it "数量为1" do
          QuestionVote.count.should == 1 
        end

      end


    end



    describe "检测 vote 相关方法" do
      describe "vote_up_by!" do
        before {
          @question.vote_up_by! @vote_user
        }

        it {
          QuestionVote.count.should == 1
        }

        it {
          @question.vote_sum.should == 1
        }
      end


      describe "vote_down_by!" do
        before {
          @question.vote_down_by! @vote_user
        }

        it {
          QuestionVote.count.should == 1
        }

        it {
          @question.vote_sum.should == -1
        }
      end


      describe "vote_cancel_by!" do
        before {
          @question.vote_cancel_by! @vote_user
        }

        it {
          QuestionVote.count.should == 1
        }

        it {
          @question.vote_sum.should == 0
        }
      end


    end




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
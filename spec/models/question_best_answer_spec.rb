require "spec_helper"

describe Question do
  # 创建一个问题
  before{
    @question = FactoryGirl.create(:question)
    @creator = @question.creator
    @creator.add_credit(1000, :test, @creator)
  }

  it{
    @question.reward.should == nil
  }

  it{
    @creator.credit_value.should == 1000
  }

  context '问题没有设置悬赏值，设置最佳答案' do
    before{
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)

      @answer_1 = @question.answers.create!(:content => "答案1", :creator => @user_1)
      @answer_2 = @question.answers.create!(:content => "答案2", :creator => @user_2)

      @question.set_best_answer(@answer_1)
      @question.reload
    }

    it{
      @question.best_answer.should == @answer_1
    }

    it{
      @creator.credit_value.should == 1005
      @user_1.credit_value.should == 20
      @user_2.credit_value.should == 0
    }

    context '修改最佳答案' do
      before{
        @question.set_best_answer(@answer_2)
      }

      it{
        @creator.credit_value.should == 1005
        @user_1.credit_value.should == 0
        @user_2.credit_value.should == 20
      }
    end
  end

  context '问题设置了悬赏值，在有5个优秀答案前，设置了最佳答案' do
    before{
      @question.set_reward(50)

      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)

      @answer_1 = @question.answers.create!(:content => "答案1", :creator => @user_1)
      @answer_2 = @question.answers.create!(:content => "答案2", :creator => @user_2)
      @answer_3 = @question.answers.create!(:content => "答案3", :creator => @user_3)

      @answer_1.vote_up_by!(@user_2)
      @answer_2.vote_up_by!(@user_3)

      @question.set_best_answer(@answer_1)
      @question.reload
    }

    it{
      @question.best_answer.should == @answer_1
    }

    it{
      @question.fine_answer_rewarded.should == true
      @question.best_answer_rewarded.should == true
    }

    it{
      @creator.credit_value.should == 955
      @user_1.credit_value.should == 80
      @user_2.credit_value.should == 35
      @user_3.credit_value.should == 0
    }

    context '修改最佳答案' do
      before{
        @user_4 = FactoryGirl.create(:user)
        @answer_4 = @question.answers.create!(:content => "答案4", :creator => @user_4)
        @answer_4.vote_up_by!(@user_3)

        @question.set_best_answer(@answer_2)
        @question.reload
      }

      it{
        @creator.credit_value.should == 955
        @user_1.credit_value.should == 35
        @user_2.credit_value.should == 80
        @user_3.credit_value.should == 0
        @user_4.credit_value.should == 10
      }
    end
  end

  context '问题设置了悬赏值，有了5个优秀答案' do
    before{
      @question.set_reward(50)

      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)
      @user_4 = FactoryGirl.create(:user)
      @user_5 = FactoryGirl.create(:user)

      @answer_1 = @question.answers.create!(:content => "答案1", :creator => @user_1)
      @answer_2 = @question.answers.create!(:content => "答案2", :creator => @user_2)
      @answer_3 = @question.answers.create!(:content => "答案3", :creator => @user_3)
      @answer_4 = @question.answers.create!(:content => "答案4", :creator => @user_4)
      @answer_5 = @question.answers.create!(:content => "答案5", :creator => @user_5)

      @answer_1.vote_up_by!(@user_2)
      @answer_2.vote_up_by!(@user_3)
      @answer_3.vote_up_by!(@user_4)
      @answer_4.vote_up_by!(@user_5)
      @answer_5.vote_up_by!(@user_1)

      @question.reload
    }

    it{
      @question.fine_answer_rewarded?.should == true
      @question.best_answer_rewarded?.should == false
    }

    it{
      @creator.credit_value.should == 950
      @user_1.credit_value.should == 35
      @user_2.credit_value.should == 35
      @user_3.credit_value.should == 35
      @user_4.credit_value.should == 35
      @user_5.credit_value.should == 35
    }

    context '设置了最佳答案' do
      before{
        @question.set_best_answer(@answer_1)
        @question.reload
      }

      it{
        @creator.credit_value.should == 955
        @user_1.credit_value.should == 80
        @user_2.credit_value.should == 35
        @user_3.credit_value.should == 35
        @user_4.credit_value.should == 35
        @user_5.credit_value.should == 35
      }

      it{
        @question.fine_answer_rewarded.should == true
        @question.best_answer_rewarded.should == true
      }

      context '修改答案' do
        before{
          @question.set_best_answer(@answer_2)
          @question.reload
        }

        it{
          @creator.credit_value.should == 955
          @user_1.credit_value.should == 35
          @user_2.credit_value.should == 80
          @user_3.credit_value.should == 35
          @user_4.credit_value.should == 35
          @user_5.credit_value.should == 35
        }
        context '增加优秀答案' do
          before{
            @user_6 = FactoryGirl.create(:user)
            @answer_6 = @question.answers.create!(:content => "答案6", :creator => @user_6)
            @answer_6.vote_up_by!(@user_1)
          }

          it{
            @user_6.credit_value.should == 10
          }
        end
      end
    end
  end
end
require "spec_helper"

describe Question do
  before{
    @question = FactoryGirl.create(:question)
    @user = @question.creator
  }

  it{
    @user.credit_value.should == 0
  }

  it{
    @question.reward.should == nil
  }

  context '贡献值不足，给问题设置悬赏值失败' do
    it{
      expect {
        @question.set_reward(100)
      }.to raise_error(RuntimeError)
      @question = @question.reload
      @user.credit_value.should == 0
      @question.reward.should == nil
    }
  end

  context '贡献值设置成功' do
    before{
      @user.add_credit(1000, :test, @user)
      @question.set_reward(100)
      @question = @question.reload
    }

    it{
      @user.credit_value.should == 900
      @question.reward.should == 100
    }

    context '尝试减少贡献值,失败' do
      it{
        expect {
          @question.set_reward(50)
        }.to raise_error(RuntimeError)

        @user.credit_value.should == 900
        @question.reward.should == 100
      }
    end

    context '增加贡献值' do
      before{
        @question.set_reward(200)
        @question = @question.reload
      }

      it{
        @user.credit_value.should == 800
        @question.reward.should == 200
      }
    end

    context '设置最佳答案' do
      before{
        @user_2 = FactoryGirl.create(:user)
        @answer = @question.answers.create!(:content => "yy", :creator => @user_2)
      }

      it{
        @user_2.credit_value.should == 0
      }

      it{
        @question.set_best_answer(@answer)
        @user_2.credit_value.should == 100
      }
    end
  end
end
require "spec_helper"

describe KnowledgeQuestionFav do
  before{
    # 用户 1 2
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    # 测试题 1 2 3 4 5
    @knowledge_question_1 = FactoryGirl.create :knowledge_question
    @knowledge_question_2 = FactoryGirl.create :knowledge_question
    @knowledge_question_3 = FactoryGirl.create :knowledge_question
    @knowledge_question_4 = FactoryGirl.create :knowledge_question
    @knowledge_question_5 = FactoryGirl.create :knowledge_question
  }

  it{
    @user_1.fav_knowledge_questions.should == []
    @user_2.fav_knowledge_questions.should == []
  }

  describe "进行收藏" do
    before{
      # 用户 1 收藏 1 2 4
      Timecop.travel(Time.now - 3.hours) do
        @user_1.fav(@knowledge_question_1)
        @user_1.fav(@knowledge_question_1)
      end
      Timecop.travel(Time.now - 2.hours) do
        @user_1.fav(@knowledge_question_2)
      end
      Timecop.travel(Time.now - 1.hours) do
        @user_1.fav(@knowledge_question_4)
      end
      # 用户 2 收藏 2 3 4 5
      Timecop.travel(Time.now - 4.hours) do
        @user_2.fav(@knowledge_question_2)
      end
      Timecop.travel(Time.now - 3.hours) do
        @user_2.fav(@knowledge_question_3)
      end
      Timecop.travel(Time.now - 2.hours) do
        @user_2.fav(@knowledge_question_4)
      end
      Timecop.travel(Time.now - 1.hours) do
        @user_2.fav(@knowledge_question_5)
      end
    }

    it{
      # 用户 1 收藏列表 1 2 4
      @user_1.fav_knowledge_questions.should == [
        @knowledge_question_4,
        @knowledge_question_2,
        @knowledge_question_1
      ]
    }
    it{
      # 用户 2 收藏列表 2 3 4 5
      @user_2.fav_knowledge_questions.should == [
        @knowledge_question_5,
        @knowledge_question_4,
        @knowledge_question_3,
        @knowledge_question_2
      ]
    }

    describe "取消收藏" do
      before{
        # 用户 1 取消收藏 2
        @user_1.cancel_fav(@knowledge_question_2)
        @user_1.cancel_fav(@knowledge_question_2)
        # 用户 2 取消收藏 4
        @user_2.cancel_fav(@knowledge_question_4)
      }

      it{
        # 用户 1 收藏列表 1 4
        @user_1.fav_knowledge_questions.should == [
          @knowledge_question_4,
          @knowledge_question_1
        ]
      }

      it{
        # 用户 1 收藏列表 2 3 5
        @user_2.fav_knowledge_questions.should == [
          @knowledge_question_5,
          @knowledge_question_3,
          @knowledge_question_2
        ]
      }
    end
  end
end
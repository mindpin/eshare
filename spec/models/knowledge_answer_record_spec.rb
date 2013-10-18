require "spec_helper"

describe KnowledgeAnswerRecord do
  
  describe "没创建 knowledge_answer_record" do

    before {
      @knowledge_question     = FactoryGirl.create :knowledge_question
      @user         = FactoryGirl.create :user
    }

    it "user correct_count" do
      @knowledge_question.correct_count_of_user(@user).should == 0
    end

    it "user error_count" do
      @knowledge_question.error_count_of_user(@user).should == 0
      @knowledge_question.correct_count_of_user(@user).should == 0
    end

    describe "添加 correct_count" do
      before {
        @knowledge_question.increase_correct_count_of_user(@user)
      }

      it "correct_count" do
        @knowledge_question.correct_count_of_user(@user).should == 1
      end

      it "error_count" do
        @knowledge_question.error_count_of_user(@user).should == 0
      end

    end


    describe "添加 error_count" do
      before {
        @knowledge_question.increase_error_count_of_user(@user)
      }

      it "correct_count" do
        @knowledge_question.correct_count_of_user(@user).should == 0
      end

      it "error_count" do
        @knowledge_question.error_count_of_user(@user).should == 1
      end

    end

  end



  describe "有创建 knowledge_answer_record" do

    before {
      @knowledge_question     = FactoryGirl.create :knowledge_question
      @user         = FactoryGirl.create :user
      @knowledge_answer_record  = FactoryGirl.create :knowledge_answer_record, 
                                    :knowledge_question => @knowledge_question,
                                    :correct_count => 1,
                                    :error_count => 0,
                                    :user => @user

    }

    it "user correct_count" do
      @knowledge_question.correct_count_of_user(@user).should == 1
    end

    it "user error_count" do
      @knowledge_question.error_count_of_user(@user).should == 0
    end

    describe "添加 correct_count" do
      before {
        @knowledge_question.increase_correct_count_of_user(@user)
      }

      it "correct_count" do
        @knowledge_question.correct_count_of_user(@user).should == 2
      end

      it "error_count" do
        @knowledge_question.error_count_of_user(@user).should == 0
      end

    end



    describe "添加 error_count" do
      before {
        @knowledge_question.increase_error_count_of_user(@user)
      }

      it "correct_count" do
        @knowledge_question.correct_count_of_user(@user).should == 1
      end

      it "error_count" do
        @knowledge_question.error_count_of_user(@user).should == 1
      end

    end
  end

  describe "用户的做题历史" do
    before{
      # 创建五个问题 1 2 3 4 5
      @knowledge_question_1 = FactoryGirl.create :knowledge_question
      @knowledge_question_2 = FactoryGirl.create :knowledge_question
      @knowledge_question_3 = FactoryGirl.create :knowledge_question
      @knowledge_question_4 = FactoryGirl.create :knowledge_question
      @knowledge_question_5 = FactoryGirl.create :knowledge_question
      # 创建两个用户 1 2
      @user_1 = FactoryGirl.create :user
      @user_2 = FactoryGirl.create :user
      # 用户 1 做 1 2 3 1 4
      Timecop.travel(Time.now - 5.hours) do
        @knowledge_question_1.increase_correct_count_of_user(@user_1)
      end
      Timecop.travel(Time.now - 4.hours) do
        @knowledge_question_2.increase_correct_count_of_user(@user_1)
      end
      Timecop.travel(Time.now - 3.hours) do
        @knowledge_question_3.increase_correct_count_of_user(@user_1)
      end
      Timecop.travel(Time.now - 2.hours) do
        @knowledge_question_1.increase_correct_count_of_user(@user_1)
      end
      Timecop.travel(Time.now - 1.hours) do
        @knowledge_question_4.increase_correct_count_of_user(@user_1)
      end
      # 用户 2 做 1 2 2 1 5
      Timecop.travel(Time.now - 5.hours) do
        @knowledge_question_1.increase_correct_count_of_user(@user_2)
      end
      Timecop.travel(Time.now - 4.hours) do
        @knowledge_question_2.increase_correct_count_of_user(@user_2)
      end
      Timecop.travel(Time.now - 3.hours) do
        @knowledge_question_2.increase_correct_count_of_user(@user_2)
      end
      Timecop.travel(Time.now - 2.hours) do
        @knowledge_question_1.increase_correct_count_of_user(@user_2)
      end
      Timecop.travel(Time.now - 1.hours) do
        @knowledge_question_5.increase_correct_count_of_user(@user_2)
      end
    }

    it{
      # 用户 1 的历史 4 1 3 2
      @user_1.history_knowledge_questions.should == [
        @knowledge_question_4,
        @knowledge_question_1,
        @knowledge_question_3,
        @knowledge_question_2
      ]
      # 用户 2 的历史 5 1 2
      @user_2.history_knowledge_questions.should == [
        @knowledge_question_5,
        @knowledge_question_1,
        @knowledge_question_2
      ]
    }
  end

  

end
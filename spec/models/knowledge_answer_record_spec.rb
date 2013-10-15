require "spec_helper"

describe KnowledgeAnswerRecord do
  
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
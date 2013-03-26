require "spec_helper"

describe Question do
  describe '不能为空较验' do
    before(:all) {
      @question = FactoryGirl.create(:question)
      @user = FactoryGirl.create(:user)

      3.times { FactoryGirl.create(:question) }
      @questions = Question.all
    }
    
    it "title should not be empty" do
      @question.title.should_not be_empty
    end

    it "content should not be empty" do
      @question.content.should_not be_empty
    end

    it "creator should not be empty" do
      @question.creator.class.should == @user.class
    end

    it "should order by id desc" do
      @questions.last.id.should be < @questions.first.id
    end

  end
end
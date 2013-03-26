require "spec_helper"

describe Answer do
  describe '不能为空较验' do
    before(:all) {
      @answer = FactoryGirl.create(:answer)

      3.times { FactoryGirl.create(:answer) }
      @answers = Answer.all

      p @answers
    }

    it "content should not be empty" do
      @answer.content.should_not be_empty
    end

    it "creator should not be empty" do
      @answer.creator.should be_a(User)
    end

    it "the question of answer should not be empty" do
      @answer.question.should be_a(Question)
    end

    it "should order by id desc" do
      @answers.last.id.should be < @answers.first.id
    end

  end
end
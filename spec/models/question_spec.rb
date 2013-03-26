require "spec_helper"

describe Question do
  describe '不能为空较验' do
    before(:all) {

      3.times { FactoryGirl.create(:question) }
      @questions = Question.all
    }
    
   

    it "should order by id desc" do
      @questions.last.id.should be < @questions.first.id
    end

  end
end
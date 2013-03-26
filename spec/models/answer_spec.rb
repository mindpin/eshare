require "spec_helper"

describe Answer do
  describe 'Validation' do
    before {
      3.times { FactoryGirl.create(:answer) }
      @answers = Answer.all
    }


    it "should order by id desc" do
      @answers.last.id.should be < @answers.first.id
    end


  end
end
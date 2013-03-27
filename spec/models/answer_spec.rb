require "spec_helper"

describe Answer do
  describe 'Validation' do
    before {
      3.times { FactoryGirl.create(:answer) }
      @answers = Answer.all
    }


    it "should order by vote_sum desc" do
      @answers.last.vote_sum.should be < @answers.second.vote_sum
      @answers.second.vote_sum.should be < @answers.first.vote_sum
    end


  end
end
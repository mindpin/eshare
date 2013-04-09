require 'spec_helper'

describe TestOption do
  let(:test_option){FactoryGirl.create(:test_option)}

  let(:scoring_result){
    {
      :count => 10,
      :point => 4
    }
  }

  let(:scoring) {TestOption::Scoring.new scoring_result}

  describe TestOption::Scoring do
    subject {scoring}

    its(:count){ should eq 10}
    its(:point){ should eq 4 }
  end

  describe TestOption::Rule do
    let(:result){
      {
        :single_choice =>   scoring_result,
        :multiple_choice => scoring_result,
        :fill =>            scoring_result,
        :true_false =>      scoring_result
      }
    }

    subject{TestOption::Rule.new result}

    it { subject.single_choice.result.should eql scoring.result }
    it { subject.multiple_choice.result.should eql scoring.result }
    it { subject.fill.result.should eql scoring.result }
    it { subject.true_false.result.should eql scoring.result }
    its(:result) { should eq result}
  end
end




















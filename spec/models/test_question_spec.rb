require 'spec_helper'

describe TestQuestion do
  let(:test_question) {FactoryGirl.build :test_question}
  describe '#answer_choice=' do
    context '单选' do
      before {test_question.kind = 'SINGLE_CHOICE'}
      it {
        expect{
          test_question.answer_choice=('B')
        }.to change{test_question.answer_choice_mask}.from(nil).to(2)
      }
    end

    context '多选' do
      before {test_question.kind = 'MULTIPLE_CHOICE'}
      it {
        expect{
          test_question.answer_choice=('BDE')
        }.to change{ test_question.answer_choice_mask}.from(nil).to(26)
      }
    end
  end

  describe '.answer_choice' do
    subject {test_question.answer_choice}
    before do
      test_question.kind = 'MULTIPLE_CHOICE'
      test_question.answer_choice = 'CE'
    end

    it {should be_an String}
    it {should include('C','E')}
  end

  describe TestQuestion::ChoiceOptions do
    let(:options) {{'A' => '1', 'B' => '2', 'C' => '3', 'D' => '4', 'E' => '5'}}
    subject {TestQuestion::ChoiceOptions.new options}

    its(:a) {should eq '1'}
    its(:b) {should eq '2'}
    its(:c) {should eq '3'}
    its(:d) {should eq '4'}
    its(:e) {should eq '5'}
  end

end













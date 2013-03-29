require 'spec_helper'

describe TestPaperItem do
  describe '#answer_choice=' do
    let(:test_paper_item) {FactoryGirl.build :test_paper_item}
    context '单选' do    
      it {
        expect{
          test_paper_item.answer_choice=('B')
        }.to change{test_paper_item.answer_choice_mask}.from(nil).to(2)
      }
    end

    context '多选' do    
      it {
        expect{
          test_paper_item.answer_choice=('BDE')
        }.to change{ test_paper_item.answer_choice_mask}.from(nil).to(26)
      }
    end
  end
  context '算分方法' do
    let(:test_paper_item) {FactoryGirl.create :test_paper_item}
    let(:test_question) {test_paper_item.test_question}
    let(:course) {test_question.course}
    let(:scoring_result){{:count => 10, :point => 4}}
    let(:result){
      {
        :single_choice =>   scoring_result,
        :multiple_choice => scoring_result,
        :fill =>            scoring_result,
        :true_false =>      scoring_result
      }
    }
    before do
      FactoryGirl.create :test_option, :course => course, :test_option_rule => result
      test_question.answer_choice = 'D';test_question.save
    end

    subject {test_paper_item}

    its(:point) {should be 4}

    context '答对' do
      before {subject.answer_choice = 'D';subject.save}
      its(:score?) {should be true}
    end

    context '答错' do
      before {subject.answer_choice = 'A';subject.save}
      its(:score?) {should be false}
    end
  end 
end







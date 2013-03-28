require 'spec_helper'

describe TestPaperItem do
  let(:test_paper_item) {FactoryGirl.build :test_paper_item}
  describe '#answer_choice=' do
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
end
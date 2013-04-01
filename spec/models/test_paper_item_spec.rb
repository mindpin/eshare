require 'spec_helper'

describe TestPaperItem do
  describe '#answer_choice=' do
    before {@test_paper_item = FactoryGirl.build :test_paper_item}
    context '单选' do    
      it {
        expect{
          @test_paper_item.answer_choice=('B')
        }.to change{@test_paper_item.answer_choice_mask}.from(nil).to(2)
      }
    end

    context '多选' do    
      it {
        expect{
          @test_paper_item.answer_choice=('BDE')
        }.to change{@test_paper_item.answer_choice_mask}.from(nil).to(26)
      }
    end
  end
  context '算分方法' do
    before do
      @test_paper_item = FactoryGirl.create :test_paper_item
      @test_question = @test_paper_item.test_question
      @course = @test_question.course
      @scoring_result = {:count => 10, :point => 4}
      @result = {
        :single_choice =>   @scoring_result,
        :multiple_choice => @scoring_result,
        :fill =>            @scoring_result,
        :true_false =>      @scoring_result
      }
    end

    before do
      FactoryGirl.create :test_option, :course => @course, :test_option_rule => @result
      @test_question.answer = 'D';@test_question.save
    end

    it {@test_paper_item.point.should be 4}

    context '答对' do
      before {@test_paper_item.answer = 'D';@test_paper_item.save}
      it {@test_paper_item.score?.should be true}
    end

    context '答错' do
      before {@test_paper_item.answer = 'A';@test_paper_item.save}
      # it {@test_paper_item.answer_choice.should == @test_paper_item.test_question.answer_choice}
      it {@test_paper_item.score?.should be false}
    end
  end 
end







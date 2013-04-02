require 'spec_helper'

describe TestPaperItem do
  before do
    @test_paper_item = FactoryGirl.build :test_paper_item
    @test_question = @test_paper_item.test_question
  end

  describe '#answer_choice=' do
    context '单选' do
      before {@test_question.kind = 'SINGLE_CHOICE'}
      it {
        expect{
          @test_paper_item.answer_choice=('B')
        }.to change{@test_paper_item.answer_choice_mask}.from(nil).to(2)
      }
    end

    context '多选' do
      before {@test_question.kind = 'MULTIPLE_CHOICE'}
      it {
        expect{
          @test_paper_item.answer_choice=('BDE')
        }.to change{@test_paper_item.answer_choice_mask}.from(nil).to(26)
      }
    end
  end
  context '算分方法' do
    before do
      @course = @test_question.course
      @scoring_result = {:count => 10, :point => 4}
      @result = {
        :single_choice =>   @scoring_result,
        :multiple_choice => @scoring_result,
        :fill =>            @scoring_result,
        :true_false =>      @scoring_result
      }
      FactoryGirl.create :test_option, :course => @course, :test_option_rule => @result
      @test_question.kind = 'FILL'
      @test_question.answer = 'D'
      @test_question.save
    end

    it {@test_paper_item.point.should be 4}

    context '答对' do
      before {@test_paper_item.answer = 'D';@test_paper_item.save}
      it {@test_paper_item.score?.should be true}
    end

    context '答错' do
      before {@test_paper_item.answer = 'A';@test_paper_item.save}
      it {@test_paper_item.score?.should be false}
    end
  end

  describe '#each_fill_field' do
    subject {@test_paper_item.each_fill_field(&lambda{|_| _})}
    before do
      @test_question.kind = 'FILL'
      @test_question.title = '*heihei*haha*xixi*'
      @test_question.save
    end

    it {should be_an Enumerator}
    it 'yields only asterisks' do
      subject.to_a.count.should_not be 0
      subject.to_a.count('*').should eq subject.to_a.count
    end
  end
end






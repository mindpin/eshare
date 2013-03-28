require 'spec_helper.rb'

describe TestPaper do
  let(:course) {FactoryGirl.create(:course)}
  let(:user)   {FactoryGirl.create(:user)}
  let(:paper)  {TestPaper.make_test_paper_for(course, user)}
  before       {1.upto(20){FactoryGirl.create(:test_question, :course => course)}}

  describe '.make_test_paper_for' do
    context '创建一个新试卷' do
      subject {paper}

      its(:user)   {should eq user}
      its(:course) {should eq course}
      it '随机选10道题组卷' do
        paper.test_questions.count.should eq 10
      end
    end
  end

  describe '#find_item_for' do
    let(:question) {paper.test_questions.first}
    subject        {paper.find_item_for question}

    it {should be_a TestPaperItem}
    its(:test_question) {should eq question}
  end
end


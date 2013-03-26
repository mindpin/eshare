require 'spec_helper.rb'

describe TestPaper do
  describe '.make_test_paper_for' do
    let(:course) {FactoryGirl.create(:course)}
    let(:user)   {FactoryGirl.create(:user)}

    subject      {TestPaper.make_test_paper_for(course, user)}

    before{
      1.upto(20){FactoryGirl.create(:test_question, :course => course)}

    }

    context '创建一个新试卷' do
      its(:user)   {should eq user}
      its(:course) {should eq course}
      it '随机选10道题组卷' do
        subject.test_questions.count.should eq 10
      end
    end

  end
end


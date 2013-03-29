require 'spec_helper.rb'

describe TestPaper do
  let(:course) {FactoryGirl.create(:course)}
  let(:user)   {FactoryGirl.create(:user)}
  let(:paper)  {TestPaper.find_by_user_id_and_course_id(user.id, course.id)}
  let(:scoring_result) {{:count => 4, :point => 3}}
  let(:result) {{
    :single_choice =>   scoring_result,
    :multiple_choice => scoring_result,
    :fill =>            scoring_result,
    :true_false =>      scoring_result
  }}

  before do
    FactoryGirl.create :test_option, :course => course, :test_option_rule => result
    TestPaper.make_test_paper_for(course, user)
  end

  describe '.make_test_paper_for' do
    subject {paper}

    its(:user)   {should eq user}
    its(:course) {should eq course}
  end

  describe '#select_questions' do
    subject {paper.test_questions.with_kind('FILL').count}
    context '题目不够组卷参数要求时' do
      context '题库内相应类型题目为空时' do
        before {6.times {FactoryGirl.create(:test_question, :course => course, :kind => 'MULTIPLE_CHOICE')}}
        it {should be 0}
      end
      context '题库内相应题目不够时' do
        before do
          3.times {FactoryGirl.create(:test_question, :course => course, :kind => 'FILL')}
          6.times {FactoryGirl.create(:test_question, :course => course, :kind => 'TRUE_FALSE')}
          paper.test_questions = paper.select_questions
        end
        it {should be 3}
      end
    end

    context '题目超过组卷参数要求时' do
      before do
        5.times {FactoryGirl.create(:test_question, :course => course, :kind => 'FILL')}
        6.times {FactoryGirl.create(:test_question, :course => course, :kind => 'SINGLE_CHOICE')}
        paper.test_questions = paper.select_questions
      end
      it {should be 4}
    end
  end

  describe '#find_item_for' do
    before do
      5.times {FactoryGirl.create(:test_question, :course => course, :kind => 'FILL')}
      6.times {FactoryGirl.create(:test_question, :course => course, :kind => 'SINGLE_CHOICE')}
      paper.test_questions = paper.select_questions
    end
    let(:question) {paper.test_questions.first}
    subject        {paper.find_item_for question}

    it {should be_a TestPaperItem}
    its(:test_question) {should eq question}
  end
end


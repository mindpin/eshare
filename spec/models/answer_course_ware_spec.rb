require 'spec_helper'

describe AnswerCourseWare do
  describe AnswerCourseWare::AnswerMethods do
    let(:answer) {FactoryGirl.create :answer}
    let(:course_ware) {FactoryGirl.create :course_ware}

    describe '#add_course_ware' do
      before {answer.add_course_ware course_ware}

      it 'attaches course_ware to answser' do
        answer.course_wares.should include course_ware
      end

      it 'relates answer to course_ware' do
        course_ware.answers.should include answer
      end
    end
  end
end

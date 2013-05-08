require 'spec_helper'

describe CourseSubjectManagership do
  let(:course_subject){FactoryGirl.create :course_subject}
  let(:user)          {course_subject.creator}
  let(:user1)         {FactoryGirl.create(:user)}

  context '#add_manager(user)' do
    it{
      expect {
        course_subject.add_manager(user1)
      }.to change {
        CourseSubjectManagership.all.count
      }.by(1)
    }

    it{
      expect {
        course_subject.add_manager(user)
      }.to change {
        CourseSubjectManagership.all.count
      }.by(0)
    }
  end

  context '#remove_manager(user)' do
    before{course_subject.add_manager(user1)}
    it{
      expect {
        course_subject.remove_manager(user1)
      }.to change {
        CourseSubjectManagership.all.count
      }.by(-1)
    }
    it{
      expect {
        course_subject.remove_manager(user)
      }.to change {
        CourseSubjectManagership.all.count
      }.by(0)
    }
  end
end
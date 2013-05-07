require 'spec_helper'

describe CourseSubject do
  let(:course)        {FactoryGirl.create(:course)}
  let(:course_subject){FactoryGirl.create :course_subject}
  let(:user)          {course_subject.creator}
  let(:user1)         {FactoryGirl.create(:user)}
  
  context '#add_course(course, user)' do
    it{
      expect {
        course_subject.add_course(course, user)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(1)
    }

    it{
      expect {
        course_subject.add_course(course, user1)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(0)
    }

    it{
      expect {
        course_subject.add_course(course, user)
        course_subject.add_course(course, user)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(1)
    }

    it{
      expect {
        course_subject.add_manager(user1)
        course_subject.add_course(course, user1)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(1)
    }
  end

  context '#remove_course(course, user)' do
    before{ course_subject.add_course(course, user) }
    it{
      expect {
        course_subject.remove_course(course, user)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(-1)
    }

    it{
      expect {
        course_subject.remove_course(course, user1)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(0)
    }

    it{
      expect {
        course_subject.remove_course(course, user)
        course_subject.remove_course(course, user)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(-1)
    }

    it{
      expect {
        course_subject.add_manager(user1)
        course_subject.remove_course(course, user1)
      }.to change {
        CourseSubjectCourse.all.count
      }.by(-1)
    }
  end

end
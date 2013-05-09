require 'spec_helper'

describe CourseSubjectFollow do

  let(:course_subject){FactoryGirl.create(:course_subject)}
  let(:user){FactoryGirl.create(:user)}
  let(:user1){FactoryGirl.create(:user)}

  context '#follow_by_user(user)' do
    it{
      expect {
        course_subject.follow_by_user(user)
        course_subject.follow_by_user(user)
      }.to change {
        CourseSubjectFollow.all.count
      }.by(1)
    }
  end

  context '#unfollow_by_user(user)' do
    before{course_subject.follow_by_user(user)}
    it{
      expect {
        course_subject.unfollow_by_user(user)
      }.to change {
        CourseSubjectFollow.all.count
      }.by(-1)
    }
    it{
      expect {
        course_subject.unfollow_by_user(user1)
      }.to change {
        CourseSubjectFollow.all.count
      }.by(0)
    }
  end
end
require "spec_helper"

describe CourseAttitude do
  let(:course)   {FactoryGirl.create :course}
  let(:user)     {FactoryGirl.create :user}
  let(:attitude) {user.set_course_attitude course, "LIKE"}

  describe CourseAttitude::CourseMethods do
    before {attitude}

    shared_examples "kind related methods" do |kind|
      downcase = kind.to_s.downcase

      context kind do
        before {user.set_course_attitude course, kind}

        describe "#{downcase}_attitude_users" do
          subject {course.send "#{downcase}_attitude_users"}

          it          {should be_an ActiveRecord::Relation}
          its(:first) {should be_an User}
        end

        describe "#{downcase}_attitude_users_count" do
          subject {course.send "#{downcase}_attitude_users_count"}

          it {should be 1}
        end
      end
    end

    CourseAttitude::VALID_KINDS.each do |kind|
      it_should_behave_like "kind related methods", kind
    end
  end

  describe CourseAttitude::UserMethods do
    describe "#set_course_attitude" do
      subject {attitude}

      it           {should be_a CourseAttitude}
      its(:user)   {should eq user}
      its(:course) {should eq course}
      its(:kind)   {should eq "LIKE"}

      context "it only creates one CourseAttitude instance for a certain user a nd a certain course" do
        before {subject}

        it {expect {subject}.not_to change {user.course_attitudes.size}}
      end
    end
  end
end

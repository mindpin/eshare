require "spec_helper"

describe Course do
  
  context '签到模块' do
    before do
      @user   = FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
    end

    describe '#sign' do
      it{expect {@course.sign(@user)}.to change {CourseSign.count}.by(1)}
    end

    describe '#current_streak_for' do
      context '昨天没有签到' do
        it {@course.current_streak_for(@user) == 1}
      end

      context '昨天前天连续签到了' do
        before do
          Timecop.travel(Date.today - 2)
          @course.sign(@user)
          Timecop.travel(Date.today - 1)
          @course.sign(@user)
        end

        it {@course.current_streak_for(@user) == 3}
      end
    end

    describe '#signs_count' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      let(:user3) {FactoryGirl.create :user}
      let(:course2) {FactoryGirl.create :course}
      before do
        course2.sign(user1)
        @course.sign(user1)
        @course.sign(user2)
        @course.sign(user3)
      end
      it{ @course.signs_count == 3 }
      it{ course2.signs_count == 1 }
    end

    describe '#sign_number' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      before do 
        @course.sign(user1)
        @course.sign(user2)
      end
      it{ @course.sign_number(user2) == 2}
    end

    describe '#current_signs_count' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      let(:user3) {FactoryGirl.create :user}
      let(:course2) {FactoryGirl.create :course}
      before do
        course2.sign(user1)
        @course.sign(user1)
        @course.sign(user2)
        @course.sign(user3)
      end
      it {@course.current_signs_count.should == 3}
    end
  end
end
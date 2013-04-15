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
        it {
          @course.current_streak_for(@user).should == 0
        }

        it {
          @course.sign(@user)
          @course.current_streak_for(@user).should == 1
        }
      end

      context '昨天有签到' do
        before do
          Timecop.travel(Time.now - 1.day) do
            @course.sign(@user)
          end
        end

        it {
          @course.course_signs.count.should == 1
        }

        it {
          @course.sign(@user)
          @course.current_streak_for(@user).should == 2
        }

        it {
          @course.sign(@user)
          @course.course_signs.count.should == 2
        }
      end

      context '昨天前天连续签到了' do
        before do
          Timecop.travel(Time.now - 2.day) do
            @course.sign(@user)
          end

          Timecop.travel(Time.now - 1.day) do
            @course.sign(@user)
          end
        end

        it {
          @course.current_streak_for(@user).should == 0
        }

        it {
          @course.sign(@user)
          @course.current_streak_for(@user).should == 3
        }
      end

      context '不能连续签到' do
        before {
          @course.sign(@user)
          @course.sign(@user)
          @course.sign(@user)
          @course.sign(@user)
        }

        it {
          @course.current_streak_for(@user).should == 1
        }

        it {
          @course.course_signs.count.should == 1
        }
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

    describe '#today_sign_order_of(user)' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      let(:user3) {FactoryGirl.create :user}
      before do 
        @course.sign(user1)
        @course.sign(user2)
      end
      it { @course.today_sign_order_of(user1) == 1 }
      it { @course.today_sign_order_of(user2) == 2 }
      it { @course.today_sign_order_of(user3).should be_blank }
      it { @course.today_sign_order_of(FactoryGirl.create :user).should be_blank }
    end

    describe '#today_signs_count' do
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
      it {@course.today_signs_count.should == 3}
      it {course2.today_signs_count.should == 1}
    end
  end
end
require "spec_helper"

describe Course do
  
  context '签到模块' do
    before do
      @user =   FactoryGirl.create(:user)
      @course = FactoryGirl.create(:course)
    end

    describe '.sign' do
      before do
        @course.sign(@user)
      end
      it{ CourseSign.all.count == 1 }
    end
    
    describe '.all_sign_count' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      let(:user3) {FactoryGirl.create :user}
      before do 
        @course.sign(user1)
        @course.sign(user2)
        @course.sign(user3)
      end
      it{ @course.all_sign_count == 3 }
    end

    describe '.sign_rank' do
      let(:user1) {FactoryGirl.create :user}
      let(:user2) {FactoryGirl.create :user}
      before do 
        @course.sign(user1)
        @course.sign(user2)
      end
      it{ @course.sign_rank(user2) == 2}
    end

    describe '.todays_signs_for_user_streak' do
      before do
        @course.sign(@user)
      end
      it{@course.todays_signs_for_user_streak(@user) == 1}
    end

    describe '.todays_signs_count' do
      before do 
        4.times{ @course.sign(@user) }
      end
      it{ @course.todays_signs_count == 4}
    end
  end
end
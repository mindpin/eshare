require 'spec_helper'

describe CoursesController do
  before {
    @user = FactoryGirl.create :user
    @course = FactoryGirl.create :course
  }

  context '#sign' do
    before {
      sign_in @user
      xhr :post, :sign, :id => @course.id
    }

    it { response.code.should == '200'}

    it {
      @course.current_streak_for(@user).should == 1
    }
  end

  context '两个不同的人签到' do
    before {
      @course.sign @user
      
      @user1 = FactoryGirl.create :user
      sign_in @user1
      xhr :post, :sign, :id => @course.id
    }

    it {
      CourseSign.count.should == 2
    }

    it {
      @course.current_streak_for(@user1).should == 1
    }

    it {
      @course.today_sign_order_of(@user).should == 1
    }

    it {
      @course.today_sign_order_of(@user1).should == 2
    }
  end
end
require 'spec_helper'

describe CourseCollect do
  before {
    @user = FactoryGirl.create(:user)
    @course_collect_0 = FactoryGirl.create(:course_collect)
    @course_collect_1 = FactoryGirl.create(:course_collect, :user => @user)
    @course_collect_2 = FactoryGirl.create(:course_collect, :user => @user)
  }

  it "查询用户创建的课程专辑" do
    @user.created_course_collects.should == [@course_collect_1, @course_collect_2]
  end
end
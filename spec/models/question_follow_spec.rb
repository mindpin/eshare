require "spec_helper"

describe QuestionFollow do
  before {
    @question     = FactoryGirl.create :question
    @user         = FactoryGirl.create :user
  }

  it "问题没被用户关注" do
    @question.follow_by_user(@user).new_record?.should == true
  end

  it "关注问题" do
    @user.follow_question(@question)

    @question.follow_by_user(@user).present?.should == true
  end

  it "取消问题" do
    @user.follow_question(@question)

    @question.follow_by_user(@user).present?.should == true

    @user.unfollow_question(@question)

    @question.follow_by_user(@user).new_record?.should == true
  end

  it "查看记录时间" do
    new_time = Timecop.freeze(Time.local(2013))
    Timecop.freeze(@new_time)

    @user.visit_question(@question)

    @question.follow_by_user(@user).last_view_time.should == new_time
  end
end
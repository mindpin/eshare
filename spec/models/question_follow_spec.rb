require "spec_helper"

describe QuestionFollow do
  before {
    @creator      = FactoryGirl.create :user
    @question     = FactoryGirl.create(:question, :creator => @creator)

    @user         = FactoryGirl.create :user

    @question_follow = @question.follow_by_user(@user)
  }

  it "问题没被其它用户关注" do
    @question.followed_by?(@user).should == false
  end

  it "问题有被自己关注" do
    @question.followed_by?(@creator).should == true
  end


  context "关注问题" do
    it "关注数量为1" do
      expect {
        @user.follow_question(@question)
      }.to change {
        @question.follows.by_user(@user).count
      }.by(1)
    end


    it "已经被关注" do
      @user.follow_question(@question)

      @question.followed_by?(@user).should == true
    end
  end


  context "取消关注" do
    it "关注数量为0" do
      expect {
        @creator.follow_question(@question)
      }.to change {
        @question.follows.by_user(@creator).count
      }.by(0)
    end


    it "已经被取消" do
      @creator.unfollow_question(@question)

      @question.followed_by?(@creator).should == false
    end
  end

  

  it "查看记录时间" do
    @user.follow_question(@question)

    new_time = Timecop.freeze(Time.local(2013))
    Timecop.freeze(new_time)

    @user.visit_question!(@question)

    @question.follow_by_user(@user).last_view_time.should == new_time
  end
end
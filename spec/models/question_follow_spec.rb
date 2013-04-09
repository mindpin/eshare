require "spec_helper"

describe QuestionFollow do
  


  describe "问题创建者" do 
    before {
      @creator      = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question, :creator => @creator)
    }

    it "问题有被自己关注" do
      @question.get_follower_by(@creator).present?.should == true
 
      @question.followed_by?(@creator).should == true
    end


    it "关注数量为0" do
      expect {
        @question.unfollow_by_user(@creator)
      }.to change {
        @question.follows.by_user(@creator).count
      }.by(-1)
    end


    it "已经被取消" do
      @question.unfollow_by_user(@creator)

      @question.followed_by?(@creator).should == false
    end

  end



  describe "其它用户" do

    before {
      @user         = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question)
    }

    it {
      @question.get_follower_by(@user).nil?.should == true
    }

    it {
      @question.followed_by?(@user).should == false
    }


    it "关注数量为1" do
      expect {
        @question.follow_by_user(@user)
      }.to change {
        @question.follows.by_user(@user).count
      }.by(1)
    end


    it "已经被关注" do
      @question.follow_by_user(@user)

      @question.followed_by?(@user).should == true
    end


    it "查看记录时间" do
      @question.follow_by_user(@user)
      last_view_time = @question.get_follower_by(@user).last_view_time

      sleep(2)

      @question.visit_by!(@user)

      @question.get_follower_by(@user).last_view_time.should > last_view_time
    end

  end


  
end
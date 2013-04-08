require "spec_helper"

describe QuestionFollow do
  


  describe "问题创建者" do 
    before {
      @creator      = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question, :creator => @creator)
    }

    it "问题有被自己关注" do
      @question.follow_by_user(@creator).persisted?.should == true
 
      @question.followed_by?(@creator).should == true
    end


    it "关注数量为0" do
      expect {
        @creator.unfollow_question(@question)
      }.to change {
        @question.follows.by_user(@creator).count
      }.by(-1)
    end


    it "已经被取消" do
      @creator.unfollow_question(@question)

      @question.followed_by?(@creator).should == false
    end

  end



  describe "其它用户" do

    before {
      @user         = FactoryGirl.create :user
      @question     = FactoryGirl.create(:question)
    }

    it {
      @question.follow_by_user(@user).new_record?.should == true
    }

    it {
      @question.followed_by?(@user).should == false
    }


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


    it "查看记录时间" do
      @user.follow_question(@question)

      new_time = Timecop.freeze(Time.local(2013))
      Timecop.freeze(new_time)

      @user.visit_question!(@question)

      @question.follow_by_user(@user).last_view_time.should == new_time
    end

  end


  
end
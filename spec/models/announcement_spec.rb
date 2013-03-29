require "spec_helper"

describe AnnouncementUser do
  describe 'Validation' do
    before {
      @user = FactoryGirl.create(:user)

      @announcement = FactoryGirl.create(:announcement)
    }

    it "用户还没有通知记录" do
      @announcement.announcement_users.by_user(@user).count.should == 0
    end
    
    it "应该是未读通知" do
      @announcement.has_readed?(@user).should == false
    end

    it "用户应该有通知记录" do
      @announcement.read_by_user(@user)
      @announcement.announcement_users.by_user(@user).count.should > 0
    end


    it "应该设置成已读" do
      @announcement.read_by_user(@user)
      @announcement.has_readed?(@user).should == true
    end

  end
end
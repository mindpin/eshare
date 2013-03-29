require "spec_helper"

describe AnnouncementUser do
  describe 'Validation' do
    before {
      @announcement = FactoryGirl.create(:announcement)
    }

    
    it "应该是未读通知" do
      @announcement.announcement_users.by_user(@user).count.should == 0
    end


    it "应该设置成已读" do
      @announcement.read_by_user(@user)
      @announcement.announcement_users.by_user(@user).first.read.should == true
    end

  end
end
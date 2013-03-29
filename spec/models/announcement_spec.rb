require "spec_helper"

describe AnnoucementUser do
  describe 'Validation' do
    before {
      @annoucement = FactoryGirl.create(:annoucement)
    }

    
    it "应该是未读通知" do
      @annoucement.annoucement_users.by_user(@user).count.should == 0
    end


    it "应该设置成已读" do
      @annoucement.read_by_user(@user)
      @annoucement.annoucement_users.by_user(@user).first.read.should == true
    end

  end
end
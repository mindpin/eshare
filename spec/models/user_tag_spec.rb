require "spec_helper"

describe User do

  before {
    @user = FactoryGirl.create(:user)
  }

  it "公有 tag 为空" do
    @user.public_tags.map(&:name).should == []
  end

  describe '私有 tag, 自动变为公有 tag' do
    before {
      @user.set_tag_list('java ruby python')
    }

    it "自动变为公有 tag" do
      @user.public_tags.map(&:name).should == ['java', 'ruby', 'python']
    end
  end

end
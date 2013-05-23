require 'spec_helper'

describe Team do
  let(:user) {FactoryGirl.create :user}

  it "用户创建Team" do
    expect{
      user.teams.create(:name => "张三")
    }.to change{User.count}.by(1)
  end


  context "查询用户创建的 teams" do
    before{ 
      user.teams.create(:name => "张三1")
      user.teams.create(:name => "张三2") 
      user.teams.create(:name => "张三3")
    }
    it{
      user.created_teams.count.should == 3
    }
  end
end
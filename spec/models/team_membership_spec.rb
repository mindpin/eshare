require 'spec_helper'

describe TeamMembership do
  let(:team) {FactoryGirl.create :team}
  let(:user) {FactoryGirl.create :user}

  let(:team1) {FactoryGirl.create :team}
  let(:team2) {FactoryGirl.create :team}
  let(:team3) {FactoryGirl.create :team}
  let(:team4) {FactoryGirl.create :team}
  let(:team5) {FactoryGirl.create :team}

  let(:user1) {FactoryGirl.create :user}
  let(:user2) {FactoryGirl.create :user}
  let(:user3) {FactoryGirl.create :user}
  let(:user4) {FactoryGirl.create :user}
  let(:user5) {FactoryGirl.create :user}

  it "增加 team 参与者" do
    expect{
      team.add_member(user)
    }.to change{TeamMembership.count}.by(1)
  end

  context "移除 team 参与者" do
    before{ team.add_member(user) }
    it{
      expect{
        team.remove_member(user)
      }.to change{TeamMembership.count}.by(-1)
    }
  end

  context "查询用户参与的 teams(用户不是创建者，而是参与者的 team)" do
    before{ 
      team1.add_member(user) 
      team2.add_member(user)
      team3.add_member(user)
      team4.add_member(user)
      team5.add_member(user)
    }

    it{
      user.joined_teams.count.should == 5
    }
  end

  context "查询 team 的参与者(不包括创建者)" do
    before{ 
      team.add_member(user1) 
      team.add_member(user2)
      team.add_member(user3)
      team.add_member(user4)
      team.add_member(user5)
    }

    it{
      team.members.count.should == 5
    }
  end
end
require 'spec_helper'

describe ActivityMembership do
  let(:activity) {FactoryGirl.create :activity}
  let(:user) {FactoryGirl.create :user}

  context '#add_member' do
    it {
      expect{
        activity.add_member(user)
      }.to change{
        activity.activity_memberships.count
      }.by(1)
    }
  end

  context '#remove_member' do
    let(:activity1) {FactoryGirl.create :activity}
    before{ 
      activity.add_member(user)
      activity1.add_member(user)
    }
    it {
      expect{
        activity.remove_member(user)
      }.to change{
        activity.activity_memberships.count
      }.by(-1)
    }
  end

  context '#members' do
    let(:activity1) {FactoryGirl.create :activity}
    let(:user1) {FactoryGirl.create :user}
    let(:user2) {FactoryGirl.create :user}
    let(:user3) {FactoryGirl.create :user} 
    before{
      activity1.add_member(user1)
      activity.add_member(user1)
      activity.add_member(user2)
      activity.add_member(user3)
    }
    it {
      activity.members.size.should == 3
    }
  end
end